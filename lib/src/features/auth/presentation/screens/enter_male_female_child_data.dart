part of '../../imports.dart';

enum ComesFrom { signUpAsPartner, signUpAsParent, editProfile }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ComesFrom from;
  final UserType? type;
  final UserType? secondaryType;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
    required this.type
  })  : from = ComesFrom.signUpAsPartner,
        secondaryType = null;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  })  : from = ComesFrom.signUpAsParent,
        type = null,
        secondaryType = UserType.parent;

  EnterMaleOrFemaleOrChildDataScreen.editProfile({
    super.key,
  }) : type = UserModel.currentUser.gender?.userType,
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

  IndividualUserModel sharedFormFieldModel =
      (UserModel.currentUser as IndividualUserModel?)?? IndividualUserModel.initial();

  UserModel get _currentUser => UserModel.currentUser;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CompleteProfileCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
      ],
      child: Column(
        spacing: 10.h,
        children: [
          if (widget.type.isNull)
            BlocBuilder<CompleteProfileCubit, AsyncState>(
              builder: (context, state) => ChooseGenderWidget(
                canChoose: !state.isLoading,
                onSelectGender: (selectedGender) => _mainType.value = selectedGender,
                genders: const [
                  UserType.male,
                  UserType.female,
                ],
              ),
            ),

          if(widget.from == ComesFrom.editProfile)
            SelectImageWidget(
              initialValue: _currentUser.avatar?? ConstantManager.defaultAvatar,
              onSelectImage: (img) => sharedFormFieldModel.copyWith(avatar: img?.path),
            ),

          ValueListenableBuilder(
            valueListenable: _mainType,
            builder: (context, value, child) => value.isFemale ?
            FemaleFields(
                secondaryUserType: widget.secondaryType,
                onFinishFemaleData: (data) => sharedFormFieldModel.merge(data)
            ) : MaleFields(
                secondaryType: widget.secondaryType,
                onFinishMaleData: (data) => sharedFormFieldModel.merge(data)
            ),
          ),

          if(widget.from != ComesFrom.editProfile)
            const ConditionsTermsAcceptance(),

          LoadingButton(
            borderRadius: ConstantManager.buttonBorderRadiusNumber,
            idleWidget: AppText(
              widget.from == ComesFrom.editProfile?
              LocaleKeys.saveChanges : LocaleKeys.confirm,
              fontSize: 16.sp,
              color: Colors.white,
              // height: ,
            ),
            call: (ctx) async => widget.from == ComesFrom.editProfile? await ctx.read<EditProfileCubit>().editProfile(
                body: sharedFormFieldModel,
                onSuccess: (){}
            ) :
            await ctx.read<CompleteProfileCubit>().completeProfile(
                  isParent: widget.secondaryType.isNotNull,
                  body: sharedFormFieldModel,
                  onSuccess: () {
                    showDefaultBottomSheet(
                        child: AppBottomSheet.small(
                            asyncCall: (context) => Go.offAll(const LoginScreen()),
                            btnTitle: LocaleKeys.back,
                            upperWidget: Column(
                              spacing: 12.h,
                              children: [
                                Lottie.asset(Assets.successDone),
                                AppText(LocaleKeys.yourRequestHasBeenSentSuccessfully, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                AppText(LocaleKeys.yourRequestWillBeReviewedByManagers, fontSize: 12.sp, color: Colors.black54),
                              ],
                            )
                        )
                    );
                    // MessageUtils.showSnackBar();
                  }
              )
          ),

          if (widget.from == ComesFrom.signUpAsPartner)
            const AlreadyHaveAccWidget()
        ],
      ),
    );
  }
}