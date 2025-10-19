part of '../../imports.dart';

enum ComesFrom { signUpAsPartner, signUpAsParent, editProfile }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ComesFrom from;
  final UserType? type;
  final UserType? secondaryType;


  const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  })  : from = ComesFrom.signUpAsParent,
        type = null,
        secondaryType = UserType.parent;

  EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
  })  : type = UserModel.currentUser?.gender?.userType ?? UserType.male,
        from = ComesFrom.signUpAsPartner,
        secondaryType = null;

  EnterMaleOrFemaleOrChildDataScreen.editProfile({
    super.key,
  })  : type = UserModel.currentUser?.gender?.userType ?? UserType.male,
        from = ComesFrom.editProfile,
        secondaryType = null;

  @override
  Widget build(BuildContext context) {
    return from == ComesFrom.editProfile?
    AppScaffold(
        appBarTitle: LocaleKeys.profile,
        body: _EnterMaleOrFemaleOrChildDataBody(from: from, type: type, secondaryType: secondaryType)
    ) :
    CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: _EnterMaleOrFemaleOrChildDataBody(from: from, type: type, secondaryType: secondaryType)
    );
  }
}

class _EnterMaleOrFemaleOrChildDataBody extends StatefulWidget {
  final ComesFrom from;

  final UserType? type;

  final UserType? secondaryType;

  const _EnterMaleOrFemaleOrChildDataBody({
    required this.from,
    required this.type,
    required this.secondaryType,
  });

  @override
  State<_EnterMaleOrFemaleOrChildDataBody> createState() => _EnterMaleOrFemaleOrChildDataBodyState();
}

class _EnterMaleOrFemaleOrChildDataBodyState extends State<_EnterMaleOrFemaleOrChildDataBody> {

  late final ValueNotifier<UserType> _mainType;

  void _init() {
    _mainType = ValueNotifier(widget.type ?? UserType.male);
  }

  IndividualUserModel sharedFormFieldModel = IndividualUserModel.initial();

  UserModel get _currentUser => UserModel.currentUser ?? UserModel.initial();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _listenToData(IndividualUserModel updatedModel) => sharedFormFieldModel = updatedModel;

  // late BlocProvider dataCubit = _mainType.value.isFemale
  //     ? BlocProvider<AddChildCubit<Female>>(create: (_) => AddChildCubit<Female>())
  //     : BlocProvider<AddChildCubit<Male>>(create: (_) => AddChildCubit<Male>());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CompleteProfileCubit()),
        BlocProvider(create: (context) => AddComplaintCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
      ],
      child: Column(
        spacing: 10.h,
        children: [
          if (widget.type.isNull)
            ChooseGenderWidget(
              titles: (element) => '${element.translate}  ${element.isFemale? AuthData.childrenNumber.value.femaleNumbers : AuthData.childrenNumber.value.maleNumbers}',
              canChoose: true,
              onSelectGender: (selectedGender) {
                _mainType.value = selectedGender;
                _listenToData(sharedFormFieldModel.copyWith(gender: Gender(userType: selectedGender)));
              },
              genders: const [
                UserType.male,
                UserType.female,
              ],
            ),

          if(widget.from == ComesFrom.editProfile)
            SelectImageWidget(
              initialValue: _currentUser.avatar,
              onSelectImage: (img) => sharedFormFieldModel.copyWith(avatar: img?.path),
            ),

          ValueListenableBuilder(
            valueListenable: _mainType,
            builder: (context, type, child) => ValueListenableBuilder(
              valueListenable: AuthData.childrenNumber,
              builder: (context, currentIndex, child) => type.isFemale ?
              FemaleFields(
                  secondaryUserType: widget.secondaryType,
                  onChangeFemaleData: (data) => _listenToData(sharedFormFieldModel.merge(data))
              ) : MaleFields(
                  secondaryType: widget.secondaryType,
                  onChangeMaleData: (data) => _listenToData(sharedFormFieldModel.merge(data))
              ),
            ),
          ),

          if(widget.from != ComesFrom.editProfile)
            const ConditionsTermsAcceptance(),

          Builder(
            builder: (context) {
              return LoadingButton(
                borderRadius: ConstantManager.buttonBorderRadiusNumber,
                idleWidget: AppText(
                  widget.from == ComesFrom.editProfile?
                  LocaleKeys.saveChanges : LocaleKeys.confirm,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
                call: (ctx) async {
                  if(widget.from == ComesFrom.editProfile){
                    await context.read<EditProfileCubit>().editProfile(
                        body: sharedFormFieldModel,
                        onSuccess: () => showDefaultBottomSheet(
                            child: const EditProfileSheet()
                        )
                    );

                  }else if(widget.from == ComesFrom.signUpAsPartner){
                    await context.read<CompleteProfileCubit>().completeProfile(
                        isParent: widget.secondaryType.isNotNull,
                        body: sharedFormFieldModel,
                        onSuccess: () {
                          showDefaultBottomSheet(
                              child: const CompleteProfileSheet()
                          );

                          // MessageUtils.showSnackBar();
                        }
                    );

                  }else if(widget.from == ComesFrom.signUpAsParent){
                    context.read<AddChildCubit>().addChild(
                        body: sharedFormFieldModel,
                        onSuccess: () {
                          showDefaultBottomSheet(
                              child: const AddChildSheet()
                          );

                          // MessageUtils.showSnackBar();
                        }
                    );
                  }

                  return;
                }
              );
            }
          ),

          if (widget.from == ComesFrom.signUpAsPartner)
            const AlreadyHaveAccWidget()
        ],
      ),
    );
  }
}