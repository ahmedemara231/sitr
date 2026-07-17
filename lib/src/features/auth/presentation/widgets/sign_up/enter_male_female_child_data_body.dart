part of '../../../imports.dart';

class _EnterMaleOrFemaleOrChildDataBody extends StatefulWidget {
  final UserGender? userType;
  final IndividualUserModel? initialValue;
  final bool withParent;
  final bool showGenderSelection;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final int? maleNum;
  final int? femaleNum;
  final Future<void> Function(BuildContext context, IndividualUserModel user)
      onClick;

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
  });

  @override
  State<_EnterMaleOrFemaleOrChildDataBody> createState() =>
      _EnterMaleOrFemaleOrChildDataBodyState();
}

class _EnterMaleOrFemaleOrChildDataBodyState
    extends State<_EnterMaleOrFemaleOrChildDataBody> {
  late final ValueNotifier<UserGender> _mainType;
  late final ValueNotifier<UserGender?> _selectedChildGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late IndividualUserModel sharedFormFieldModel;
  int _currentPage = 0;

  bool get _shouldUseGenderFirstFlow =>
      widget.withParent &&
      widget.showGenderSelection &&
      widget.initialValue.isNull;

  @override
  void initState() {
    super.initState();
    _selectedChildGender = ValueNotifier(
      widget.userType ?? widget.initialValue?.gender?.userGender,
    );
    _mainType = ValueNotifier(
      widget.userType ??
          widget.initialValue?.gender?.userGender ??
          UserGender.male,
    );
    _assignToInitial();
  }

  @override
  void dispose() {
    _mainType.dispose();
    _selectedChildGender.dispose();
    super.dispose();
  }

  void _assignToInitialValueOr(IndividualUserModel model) {
    if (widget.initialValue.isNotNull) {
      sharedFormFieldModel = widget.initialValue!;
    } else {
      sharedFormFieldModel = model;
    }
  }

  void _assignToInitial() {
    if (_mainType.value.isMale) {
      _assignToInitialValueOr(MaleModel.initial());
    } else if (_mainType.value.isFemale) {
      _assignToInitialValueOr(FemaleModel.initial());
    } else {
      _assignToInitialValueOr(IndividualUserModel.initial());
    }
  }

  void _selectChildGender(UserGender gender) {
    _selectedChildGender.value = gender;
    _mainType.value = gender;
    _assignToInitial();
  }

  void _listenToData(IndividualUserModel updatedModel) =>
      sharedFormFieldModel = updatedModel;

  Future<void> _goToDataPage() async {
    if (_selectedChildGender.value == null) {
      MessageUtils.showSnackBar(LocaleKeys.pleaseEnterTheGender);
      return;
    }

    context.hideKeyboard();
    setState(() => _currentPage = 1);
  }

  Future<void> _goToGenderPage() async {
    context.hideKeyboard();
    setState(() => _currentPage = 0);
  }

  Future<void> _submit(BuildContext ctx) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await widget.onClick.call(ctx, sharedFormFieldModel);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CompleteProfileCubit()),
        BlocProvider(create: (context) => AddChildCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
        BlocProvider(create: (context) => PersonalDataCubit()),
      ],
      child: _shouldUseGenderFirstFlow
          ? _ChildGenderFirstFlow(
              currentPage: _currentPage,
              selectedChildGender: _selectedChildGender,
              maleNum: widget.maleNum,
              femaleNum: widget.femaleNum,
              onGenderSelected: _selectChildGender,
              onContinuePressed: _goToDataPage,
              dataForm: _ChildDataForm(
                formKey: _formKey,
                mainType: _mainType,
                withParent: widget.withParent,
                showInlineGenderSelection: false,
                showBackButton: true,
                showConditionsAndTerms: widget.showConditionsAndTerms,
                showAlreadyHaveAccount: widget.showAlreadyHaveAccount,
                initialValue: widget.initialValue,
                maleNum: widget.maleNum,
                femaleNum: widget.femaleNum,
                onGenderSelected: (UserGender gender) =>
                    _mainType.value = gender,
                onImageSelected: (File? img) => _listenToData(
                  sharedFormFieldModel.copyWith(avatar: img),
                ),
                onGenderFieldsResolved: (_) => _assignToInitial(),
                onDataChanged: (IndividualUserModel data) =>
                    _listenToData(sharedFormFieldModel.merge(data)),
                onBackPressed: _goToGenderPage,
                onSubmitPressed: _submit,
              ),
            )
          : _ChildDataForm(
              formKey: _formKey,
              mainType: _mainType,
              withParent: widget.withParent,
              showInlineGenderSelection: widget.showGenderSelection,
              showConditionsAndTerms: widget.showConditionsAndTerms,
              showAlreadyHaveAccount: widget.showAlreadyHaveAccount,
              initialValue: widget.initialValue,
              maleNum: widget.maleNum,
              femaleNum: widget.femaleNum,
              onGenderSelected: (UserGender gender) => _mainType.value = gender,
              onImageSelected: (File? img) => _listenToData(
                sharedFormFieldModel.copyWith(avatar: img),
              ),
              onGenderFieldsResolved: (_) => _assignToInitial(),
              onDataChanged: (IndividualUserModel data) =>
                  _listenToData(sharedFormFieldModel.merge(data)),
              onBackPressed: _goToGenderPage,
              onSubmitPressed: _submit,
            ),
    );
  }
}
