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
    required this.userType,
    required this.showGenderSelection,
    required this.onClick,
    required this.maleNum,
    required this.femaleNum,
    this.initialValue,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
  });

  @override
  State<_EnterMaleOrFemaleOrChildDataBody> createState() =>
      _EnterMaleOrFemaleOrChildDataBodyState();
}

class _EnterMaleOrFemaleOrChildDataBodyState
    extends State<_EnterMaleOrFemaleOrChildDataBody> {
  final FirstValidationErrorFieldKeys _validationFieldKeys =
      FirstValidationErrorFieldKeys();
  final GlobalKey _stepperKey = GlobalKey();
  final Map<_ProfileFormStep, GlobalKey<FormState>> _formKeys = {
    _ProfileFormStep.mainInformation: GlobalKey<FormState>(),
    _ProfileFormStep.personalDetails: GlobalKey<FormState>(),
    _ProfileFormStep.familyAndMarriage: GlobalKey<FormState>(),
    _ProfileFormStep.lifestyleAndHealth: GlobalKey<FormState>(),
    _ProfileFormStep.faithAndPreferences: GlobalKey<FormState>(),
  };

  late IndividualUserModel _draft;
  late UserGender? _selectedGender;
  int _currentStep = 0;
  int _maxReachedStep = 0;
  bool _termsAccepted = false;

  bool get _includesGenderStep =>
      widget.withParent &&
      widget.showGenderSelection &&
      widget.initialValue.isNull;

  bool get _isFinalStep => _currentStep == _steps.length - 1;

  _ProfileFormStep get _activeStep => _steps[_currentStep];

  List<_ProfileFormStep> get _steps => [
        if (_includesGenderStep) _ProfileFormStep.gender,
        _ProfileFormStep.mainInformation,
        _ProfileFormStep.personalDetails,
        _ProfileFormStep.familyAndMarriage,
        _ProfileFormStep.lifestyleAndHealth,
        _ProfileFormStep.faithAndPreferences,
      ];

  @override
  void initState() {
    super.initState();
    _selectedGender =
        widget.userType ?? widget.initialValue?.gender?.userGender;
    _draft = widget.initialValue?.copyWith() ??
        _createDraftForGender(_selectedGender ?? UserGender.male);
  }

  IndividualUserModel _createDraftForGender(UserGender gender) {
    final GenderValueShape genderValue = GenderValueShape(userGender: gender);
    if (gender.isFemale) {
      return FemaleModel.initial().copyWith(gender: genderValue);
    }
    return MaleModel.initial().copyWith(gender: genderValue);
  }

  void _updateDraft(IndividualUserModel model) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _draft = model);
        }
      });
      return;
    }
    setState(() => _draft = model);
  }

  void _updateTermsAcceptance(bool isAccepted) {
    setState(() => _termsAccepted = isAccepted);
  }

  Future<void> _selectGender(UserGender gender) async {
    if (_selectedGender == gender) {
      return;
    }

    if (_maxReachedStep > 0) {
      final bool? shouldReset = await showCustomDialog<bool>(
        context,
        barrierDismissible: false,
        child: const _GenderResetDialog(),
      );
      if (!mounted || shouldReset != true) {
        return;
      }
    }

    setState(() {
      _selectedGender = gender;
      _draft = _createDraftForGender(gender);
      _termsAccepted = false;
      if (_maxReachedStep > 0) {
        _currentStep = 0;
        _maxReachedStep = 0;
      }
    });
  }

  Future<void> _continueFromGender() async {
    if (_selectedGender == null) {
      MessageUtils.show(
        LocaleKeys.pleaseEnterTheGender,
        state: MsgState.info,
      );
      return;
    }
    await _advance();
  }

  Future<void> _advance() async {
    context.hideKeyboard();
    if (_currentStep >= _steps.length - 1) {
      return;
    }
    setState(() {
      _currentStep++;
      if (_currentStep > _maxReachedStep) {
        _maxReachedStep = _currentStep;
      }
    });
    _revealStepper();
  }

  Future<void> _goBack() async {
    context.hideKeyboard();
    if (_currentStep == 0) {
      return;
    }
    setState(() => _currentStep--);
    _revealStepper();
  }

  void _goToReachedStep(int index) {
    if (index >= _currentStep || index > _maxReachedStep) {
      return;
    }
    context.hideKeyboard();
    setState(() => _currentStep = index);
    _revealStepper();
  }

  void _revealStepper() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final BuildContext? stepperContext = _stepperKey.currentContext;
      if (stepperContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        stepperContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    });
  }

  Future<void> _submit(BuildContext context) async {
    await widget.onClick.call(context, _draft);
  }

  Widget _buildSubform(_ProfileFormStep step) {
    switch (step) {
      case _ProfileFormStep.gender:
        return _ChildGenderStep(
          selectedGender: _selectedGender,
          maleNum: widget.maleNum,
          femaleNum: widget.femaleNum,
          onGenderSelected: _selectGender,
        );
      case _ProfileFormStep.mainInformation:
        return _MainInformationSubform(
          model: _draft,
          withParent: widget.withParent,
          validationFieldKeys: _validationFieldKeys,
          onChanged: _updateDraft,
        );
      case _ProfileFormStep.personalDetails:
        return _PersonalDetailsSubform(
          model: _draft,
          validationFieldKeys: _validationFieldKeys,
          onChanged: _updateDraft,
        );
      case _ProfileFormStep.familyAndMarriage:
        return _FamilyMarriageSubform(
          model: _draft,
          validationFieldKeys: _validationFieldKeys,
          onChanged: _updateDraft,
        );
      case _ProfileFormStep.lifestyleAndHealth:
        return _LifestyleHealthSubform(
          model: _draft,
          validationFieldKeys: _validationFieldKeys,
          onChanged: _updateDraft,
        );
      case _ProfileFormStep.faithAndPreferences:
        return _FaithPreferencesSubform(
          model: _draft,
          showConditionsAndTerms: widget.showConditionsAndTerms,
          termsAccepted: _termsAccepted,
          validationFieldKeys: _validationFieldKeys,
          onChanged: _updateDraft,
          onTermsAcceptanceChanged: _updateTermsAcceptance,
        );
    }
  }

  Widget _buildActiveStep() {
    final _ProfileFormStep step = _activeStep;
    final Widget subform = _buildSubform(step);
    if (step == _ProfileFormStep.gender) {
      return _ProfileStepCard(
        key: const ValueKey<_ProfileFormStep>(_ProfileFormStep.gender),
        step: step,
        actions: _ProfileStepActions(
          canGoBack: false,
          isFinalStep: false,
          onBackPressed: _goBack,
          onContinuePressed: _continueFromGender,
        ),
        child: subform,
      );
    }

    return _ChildDataForm(
      key: ValueKey<_ProfileFormStep>(step),
      formKey: _formKeys[step]!,
      validationFields: () => _validationFieldsFor(step),
      step: step,
      canGoBack: _currentStep > 0,
      isFinalStep: _isFinalStep,
      onBackPressed: _goBack,
      onContinuePressed: _advance,
      onSubmitPressed: _submit,
      child: subform,
    );
  }

  List<FirstValidationErrorField> _validationFieldsFor(
    _ProfileFormStep step,
  ) {
    switch (step) {
      case _ProfileFormStep.gender:
        return [];
      case _ProfileFormStep.mainInformation:
        return _mainInformationValidationFields();
      case _ProfileFormStep.personalDetails:
        return _personalDetailsValidationFields();
      case _ProfileFormStep.familyAndMarriage:
        return _familyMarriageValidationFields();
      case _ProfileFormStep.lifestyleAndHealth:
        return _lifestyleHealthValidationFields();
      case _ProfileFormStep.faithAndPreferences:
        return _faithPreferencesValidationFields();
    }
  }

  List<FirstValidationErrorField> _mainInformationValidationFields() {
    final List<FirstValidationErrorField> fields = [];
    if (widget.withParent) {
      fields.add(
        _validationField(
          fieldName: IndividualValidationField.name,
          title: LocaleKeys.name,
          value: _draft.name,
          validator: (String? value) => Validators.validateName(
            value,
            fieldTitle: LocaleKeys.name,
          ),
        ),
      );
    }
    fields.add(
      _validationField(
        fieldName: IndividualValidationField.nickname,
        title: LocaleKeys.nickname,
        value: _draft.nickName,
        validator: (String? value) => Validators.validateName(
          value,
          fieldTitle: LocaleKeys.nickname,
        ),
      ),
    );
    if (widget.withParent) {
      fields.addAll([
        _validationField(
          fieldName: IndividualValidationField.phone,
          title: LocaleKeys.phoneNumber,
          value: _draft.phone,
          validator: Validators.validatePhone,
        ),
        _validationField(
          fieldName: IndividualValidationField.age,
          title: LocaleKeys.age,
          value: _draft.age?.toString(),
          validator: (String? value) => Validators.validateAge(
            value,
            fieldTitle: LocaleKeys.age,
            isRequired: true,
          ),
        ),
      ]);
    }
    fields.add(
      _validationField(
        fieldName: IndividualValidationField.maritalStatus,
        title: LocaleKeys.maritalStatus,
        value: _draft.maritalStatus?.title,
        validator: Validators.validateEmpty,
      ),
    );
    return fields;
  }

  List<FirstValidationErrorField> _personalDetailsValidationFields() => [
        _validationField(
          fieldName: IndividualValidationField.height,
          title: LocaleKeys.tall,
          value: _draft.height,
          validator: (String? value) => Validators.validateNumeric(
            value,
            min: 75,
            max: 250,
            fieldTitle: LocaleKeys.tall,
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.weight,
          title: LocaleKeys.weight,
          value: _draft.weight,
          validator: (String? value) => Validators.validateNumeric(
            value,
            min: 30,
            max: 300,
            fieldTitle: LocaleKeys.weight,
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.currentJob,
          title: LocaleKeys.currentJob,
          value: _draft.currentJob,
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 100,
            fieldTitle: LocaleKeys.currentJob,
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.bio,
          title: LocaleKeys.quickBrief,
          value: _draft.bio,
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            fieldTitle: LocaleKeys.quickBrief,
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.city,
          title: LocaleKeys.city,
          value: _draft.cityId?.name,
          validator: Validators.validateEmpty,
        ),
        _validationField(
          fieldName: IndividualValidationField.educationLevel,
          title: LocaleKeys.educationalQualification,
          value: _draft.educationLevel,
          validator: (String? value) => Validators.validateString(
            value,
            fieldTitle: LocaleKeys.educationalQualification,
          ),
        ),
      ];

  List<FirstValidationErrorField> _familyMarriageValidationFields() {
    final List<FirstValidationErrorField> fields = [];
    if (_draft.hasChildren == true) {
      fields.addAll([
        _validationField(
          fieldName: IndividualValidationField.childrenNumber,
          title: LocaleKeys.childrenNumber,
          value: _draft.numOfChildren?.toString(),
          validator: (String? value) => Validators.validateInteger(
            value,
            min: 0,
            max: 100,
            fieldTitle: LocaleKeys.childrenNumber,
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.childCustody,
          title: LocaleKeys.nursery,
          value: _draft.childCustody?.title,
          validator: Validators.validateEmpty,
        ),
      ]);
    }
    if (_draft is FemaleModel) {
      fields.add(
        _validationField(
          fieldName: IndividualValidationField.preferredResidence,
          title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
          value: (_draft as FemaleModel).preferredResidenceAfterMarriage,
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            fieldTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
          ),
        ),
      );
    }
    return fields;
  }

  List<FirstValidationErrorField> _lifestyleHealthValidationFields() => [
        _validationField(
          fieldName: IndividualValidationField.healthConditions,
          title: LocaleKeys.diseasesIfExists,
          value: _draft.healthConditions,
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            isRequired: false,
            fieldTitle: LocaleKeys.diseasesIfExists,
          ),
        ),
      ];

  List<FirstValidationErrorField> _faithPreferencesValidationFields() {
    final List<FirstValidationErrorField> fields = [];
    if (_draft is FemaleModel) {
      fields.add(
        _validationField(
          fieldName: IndividualValidationField.hijab,
          title: LocaleKeys.areYouWaringHijab,
          value: (_draft as FemaleModel).hijab?.title,
          validator: Validators.validateEmpty,
        ),
      );
    }
    fields.addAll([
      _validationField(
        fieldName: IndividualValidationField.religiousCommitment,
        title: LocaleKeys.degreeOfCommitment,
        value: _draft.religiousCommitment?.title,
        validator: Validators.validateEmpty,
      ),
      _validationField(
        fieldName: IndividualValidationField.prohibitedThings,
        title: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        value: _draft.prohibitedThings,
        validator: (String? value) => Validators.validateString(
          value,
          min: 3,
          max: 1000,
          fieldTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        ),
      ),
    ]);
    if (widget.showConditionsAndTerms) {
      fields.add(
        _validationField(
          fieldName: IndividualValidationField.termsAcceptance,
          title: LocaleKeys.conditionsAndTerms,
          value: _termsAccepted.toString(),
          validator: (String? value) => _termsAccepted
              ? null
              : LocaleKeys.pleaseAcceptTheConditionsAndTerms,
        ),
      );
    }
    return fields;
  }

  FirstValidationErrorField _validationField({
    required String fieldName,
    required String title,
    required String? value,
    required FormFieldValidator<String?> validator,
  }) {
    return FirstValidationErrorField(
      fieldKey: _validationFieldKeys.get(fieldName),
      title: title,
      value: value,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_ProfileFormStep> steps = _steps;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => CompleteProfileCubit()),
        BlocProvider(create: (BuildContext context) => AddChildCubit()),
        BlocProvider(create: (BuildContext context) => EditProfileCubit()),
        BlocProvider(create: (BuildContext context) => PersonalDataCubit()),
      ],
      child: Column(
        children: [
          KeyedSubtree(
            key: _stepperKey,
            child: _ProfileStepperHeader(
              steps: steps,
              currentStep: _currentStep,
              maxReachedStep: _maxReachedStep,
              onStepReached: _goToReachedStep,
            ),
          ),
          16.szH,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _buildActiveStep(),
          ),
          if (_isFinalStep && widget.showAlreadyHaveAccount) ...[
            16.szH,
            const AlreadyHaveAccWidget(),
          ],
        ],
      ),
    );
  }
}
