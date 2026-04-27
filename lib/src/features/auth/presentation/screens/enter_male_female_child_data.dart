part of '../../imports.dart';

enum ScaffoldType { appScaffold, centerCard }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ScaffoldType scaffoldType;
  final IndividualUserModel? initialValue;
  final bool _withParent;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final UserGender? userType;
  final bool showGenderSelection;
  final int? maleNum;
  final int? femaleNum;
  final FormMode formMode;
  final FutureOr<void> Function()? onSkip;
  final int? currentStep;
  final int? totalSteps;

  final Future<void> Function(BuildContext context, IndividualUserModel user) onClick;

  const EnterMaleOrFemaleOrChildDataScreen.showAll({
    super.key,
    required this.scaffoldType,
    required this.onClick,
    this.showGenderSelection = true,
    this.initialValue,
    this.maleNum = 0,
    this.femaleNum = 0,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    this.userType,
    this.formMode = FormMode.all,
    this.onSkip,
    this.currentStep,
    this.totalSteps,
  }) : _withParent = true;

  const EnterMaleOrFemaleOrChildDataScreen.individual({
    super.key,
    required this.scaffoldType,
    this.showGenderSelection = false,
    this.initialValue,
    required this.onClick,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    required this.userType,
    this.formMode = FormMode.all,
    this.onSkip,
    this.currentStep,
    this.totalSteps,
  }) : _withParent = false, maleNum = null, femaleNum = null;

  @override
  Widget build(BuildContext context) {
    return scaffoldType == ScaffoldType.appScaffold?
    AppScaffold(
        appBarTitle: LocaleKeys.profile,
        body: _EnterMaleOrFemaleOrChildDataBody(
          maleNum: maleNum,
          femaleNum: femaleNum,
          userType: userType,
          withParent: _withParent,
          showGenderSelection: showGenderSelection,
          initialValue: initialValue,
          showAlreadyHaveAccount: showAlreadyHaveAccount,
          showConditionsAndTerms: showConditionsAndTerms,
          onClick: onClick,
          formMode: formMode,
          onSkip: onSkip,
          currentStep: currentStep,
          totalSteps: totalSteps,
        )
    ) :
    CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        bodyColor: AppColors.white,
        body: _EnterMaleOrFemaleOrChildDataBody(
          maleNum: maleNum,
          femaleNum: femaleNum,
          withParent: _withParent,
          showGenderSelection: showGenderSelection,
          userType: userType,
          initialValue: initialValue,
          showAlreadyHaveAccount: showAlreadyHaveAccount,
          showConditionsAndTerms: showConditionsAndTerms,
          onClick: onClick,
          formMode: formMode,
          onSkip: onSkip,
          currentStep: currentStep,
          totalSteps: totalSteps,
        )
    );
  }
}

class _EnterMaleOrFemaleOrChildDataBody extends StatefulWidget {
  final UserGender? userType;
  final IndividualUserModel? initialValue;
  final bool withParent;
  final bool showGenderSelection;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final int? maleNum;
  final int? femaleNum;
  final FormMode formMode;
  final FutureOr<void> Function()? onSkip;
  final int? currentStep;
  final int? totalSteps;
  final Future<void> Function(BuildContext context, IndividualUserModel user) onClick;

  const _EnterMaleOrFemaleOrChildDataBody({
    required this.withParent,
    this.initialValue,
    required this.userType,
    required this.showGenderSelection,
    required this.onClick,
    required this.maleNum,
    required this.femaleNum,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    this.formMode = FormMode.all,
    this.onSkip,
    this.currentStep,
    this.totalSteps,
  });

  @override
  State<_EnterMaleOrFemaleOrChildDataBody> createState() => _EnterMaleOrFemaleOrChildDataBodyState();
}

class _EnterMaleOrFemaleOrChildDataBodyState extends State<_EnterMaleOrFemaleOrChildDataBody> {

  late final ValueNotifier<UserGender> _mainType;

  void _init() {
    _mainType = ValueNotifier(
        widget.userType ??
            widget.initialValue?.gender?.userGender ??
            UserGender.male
    );
    _assignToInitial();
  }

  late IndividualUserModel sharedFormFieldModel;
  void _assignToInitialValueOr(IndividualUserModel model){
    if(widget.initialValue.isNotNull){
      sharedFormFieldModel = widget.initialValue!;

    }else{
      sharedFormFieldModel = model;
    }
  }
  void _assignToInitial(){
    if(_mainType.value.isMale){
      _assignToInitialValueOr(MaleModel.initial());

    }else if(_mainType.value.isFemale){
      _assignToInitialValueOr(FemaleModel.initial());

    }else{
      _assignToInitialValueOr(IndividualUserModel.initial());
    }
  }


  @override
  void initState() {
    _init();
    super.initState();
  }
  void _listenToData(IndividualUserModel updatedModel) => sharedFormFieldModel = updatedModel;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CompleteProfileCubit()),
        BlocProvider(create: (context) => AddChildCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
        BlocProvider(create: (context) => PersonalDataCubit()),
      ],

      child: Form(
        key: _formKey,
        child: Column(
          spacing: 10.h,
          children: [
            if (widget.currentStep != null && widget.totalSteps != null)
              RegisterStepper(
                currentStep: widget.currentStep!,
                totalSteps: widget.totalSteps!,
              ),

            if(widget.showGenderSelection)
              ChooseGenderWidget(
                // titles: (element) => element.translate,
                // titles: (element) => '${element.translate}  ${element.isFemale? AuthData.childrenNumber.value.getFemaleNumber : AuthData.childrenNumber.value.getMaleNumber}',
                titles: (element) => '${element.translate}  ${element.isFemale? widget.femaleNum : widget.maleNum}',
                canChoose: true,
                onSelectGender: (selectedGender) => _mainType.value = selectedGender,
                genders: const [
                  UserGender.male,
                  UserGender.female,
                ],
              ),

            if(widget.withParent)
              SelectImageWidget(
                initialValue: widget.initialValue?.avatar,
                onSelectImage: (img){
                  _listenToData(sharedFormFieldModel.copyWith(avatar: img));
                },
              ),

            ValueListenableBuilder(
              valueListenable: _mainType,
              builder: (context, type, child) {
                _assignToInitial();
                if(type.isFemale){
                  return FemaleFields(
                      withParent: widget.withParent,
                      initialValue: widget.initialValue,
                      mode: widget.formMode,
                      onChangeFemaleData: (data) =>
                          _listenToData(sharedFormFieldModel.merge(data))
                  );

                }else if (type.isMale){
                  return MaleFields(
                      initialValue: widget.initialValue,
                      withParent: widget.withParent,
                      mode: widget.formMode,
                      onChangeMaleData: (data) => _listenToData(sharedFormFieldModel.merge(data))
                  );

                }else{
                  return const SizedBox.shrink();
                }
              }
            ),

            if(widget.showConditionsAndTerms)
              const ConditionsTermsAcceptance(),

            AppLoadingButton(
              height: 45.h,
              borderRadius: ConstantManager.buttonBorderRadiusNumber,
              title: LocaleKeys.confirm,
                asyncCall: (ctx) async => _formKey.currentState!.validate()?
                widget.onClick.call(ctx, sharedFormFieldModel) : null
            ),

            if (widget.onSkip != null)
              TextButton(
                onPressed: () async => await widget.onSkip!(),
                child: AppText(LocaleKeys.skip),
              ),

            if (widget.showAlreadyHaveAccount)
              const AlreadyHaveAccWidget()
          ],
        ),
      ),
    );
  }
}
