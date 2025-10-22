part of '../../imports.dart';

enum ScaffoldType { appScaffold, centerCard }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ScaffoldType scaffoldType;
  final IndividualUserModel? initialValue;
  final bool _withParent;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final UserType? userType;
  final Future<void> Function(BuildContext context, IndividualUserModel user) onClick;


  const EnterMaleOrFemaleOrChildDataScreen.withParent({
    super.key,
    required this.scaffoldType,
    this.initialValue,
    required this.onClick,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
  }) : _withParent = true, userType = null;

  const EnterMaleOrFemaleOrChildDataScreen.individual({
    super.key,
    required this.scaffoldType,
    this.initialValue,
    required this.onClick,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    required this.userType,
  }) : _withParent = false;

  // const EnterMaleOrFemaleOrChildDataScreen({
  //   super.key,
  //   required this.scaffoldType,
  //   required this.withParent,
  //   this.initialValue,
  //   required this.onClick,
  //   this.showConditionsAndTerms = false,
  //   this.showAlreadyHaveAccount = false,
  // });

  @override
  Widget build(BuildContext context) {
    return scaffoldType == ScaffoldType.appScaffold?
    AppScaffold(
        appBarTitle: LocaleKeys.profile,
        body: _EnterMaleOrFemaleOrChildDataBody(
          userType: userType,
          withParent: _withParent,
          initialValue: initialValue,
          showAlreadyHaveAccount: showAlreadyHaveAccount,
          showConditionsAndTerms: showConditionsAndTerms,
          onClick: onClick,
        )
    ) :
    CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        bodyColor: AppColors.white,
        body: _EnterMaleOrFemaleOrChildDataBody(
          withParent: _withParent,
          userType: userType,
          initialValue: initialValue,
          showAlreadyHaveAccount: showAlreadyHaveAccount,
          showConditionsAndTerms: showConditionsAndTerms,
          onClick: onClick,
        )
    );
  }
}

class _EnterMaleOrFemaleOrChildDataBody extends StatefulWidget {
  final UserType? userType;
  final IndividualUserModel? initialValue;
  final bool withParent;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final Future<void> Function(BuildContext context, IndividualUserModel user) onClick;

  const _EnterMaleOrFemaleOrChildDataBody({
    required this.withParent,
    this.initialValue,
    required this.userType,
    required this.onClick,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
  });

  @override
  State<_EnterMaleOrFemaleOrChildDataBody> createState() => _EnterMaleOrFemaleOrChildDataBodyState();
}

class _EnterMaleOrFemaleOrChildDataBodyState extends State<_EnterMaleOrFemaleOrChildDataBody> {

  late final ValueNotifier<UserType> _mainType;

  void _init() {
    _mainType = ValueNotifier(widget.userType ?? UserType.male);
    _assignToInitial();
  }

  late IndividualUserModel sharedFormFieldModel;
  void _assignToInitial(){
    if(_mainType.value.isMale){
      sharedFormFieldModel = MaleModel.initial();

    }else if(_mainType.value.isFemale){
      sharedFormFieldModel = FemaleModel.initial();

    }else{
      sharedFormFieldModel = IndividualUserModel.initial();
    }
  }

  // UserModel get _currentUser => UserModel.currentUser ?? UserModel.initial();

  @override
  void initState() {
    _init();
    super.initState();
  }
  void _listenToData(IndividualUserModel updatedModel) => sharedFormFieldModel = updatedModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CompleteProfileCubit()),
        BlocProvider(create: (context) => AddChildCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
      ],
      child: Column(
        spacing: 10.h,
        children: [
          if(widget.withParent)
            ChooseGenderWidget(
              // titles: (element) => '${element.translate}  ${element.isFemale? AuthData.childrenNumber.value.femaleNumbers : AuthData.childrenNumber.value.maleNumbers}',
              titles: (element) => element.translate,
              canChoose: true,
              onSelectGender: (selectedGender) => _mainType.value = selectedGender,
              genders: const [
                UserType.male,
                UserType.female,
              ],
            ),
           
          SelectImageWidget(
            initialValue: widget.initialValue?.avatar,
            onSelectImage: (img) => sharedFormFieldModel.copyWith(avatar: img?.path),
          ),

          ValueListenableBuilder(
            valueListenable: _mainType,
            builder: (context, type, child) {
              _assignToInitial();
              if(type.isFemale){
                return FemaleFields(
                    withParent: widget.withParent, initialValue: widget.initialValue,
                    onChangeFemaleData: (data) => _listenToData(sharedFormFieldModel.merge(data))
                );

              }else if (type.isMale){
                return MaleFields(
                    initialValue: widget.initialValue,withParent: widget.withParent,
                    onChangeMaleData: (data) => _listenToData(sharedFormFieldModel.merge(data))
                );

              }else{
                return const SizedBox.shrink();
              }
            }
          ),

          if(widget.showConditionsAndTerms)
            const ConditionsTermsAcceptance(),

          LoadingButton(
            borderRadius: ConstantManager.buttonBorderRadiusNumber,
            idleWidget: AppText(
              LocaleKeys.confirm,
              fontSize: 16.sp,
              color: Colors.white,
            ),
            call: (ctx) async => widget.onClick.call(ctx, sharedFormFieldModel)
          ),

          if (widget.showAlreadyHaveAccount)
            const AlreadyHaveAccWidget()
        ],
      ),
    );
  }
}
