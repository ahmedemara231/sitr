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
  final FirstValidationErrorFieldKeys _validationFieldKeys =
      FirstValidationErrorFieldKeys();
  late IndividualUserModel sharedFormFieldModel;
  int _currentPage = 0;
  bool _conditionsAccepted = false;

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
      MessageUtils.show(
        LocaleKeys.pleaseEnterTheGender,
        state: MsgState.info,
      );
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
    await widget.onClick.call(ctx, sharedFormFieldModel);
  }

  List<FirstValidationErrorField> _validationFields() {
    final IndividualUserModel model = sharedFormFieldModel;
    final bool isFemale = _mainType.value.isFemale;
    final List<FirstValidationErrorField> fields =
        <FirstValidationErrorField>[];

    if (widget.withParent) {
      fields.add(_validationField(
        fieldName: IndividualValidationField.name,
        title: LocaleKeys.name,
        value: model.name,
        validator: (value) => Validators.validateName(
          value,
          fieldTitle: LocaleKeys.name.tr(),
        ),
      ));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.nickname,
      title: LocaleKeys.nickname,
      value: model.nickName,
      validator: (value) => Validators.validateName(
        value,
        fieldTitle: LocaleKeys.nickname.tr(),
      ),
    ));

    if (widget.withParent && !isFemale) {
      fields.add(_phoneValidationField(model));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.maritalStatus,
      title: LocaleKeys.maritalStatus,
      value: model.maritalStatus?.title,
      validator: Validators.validateEmpty,
    ));

    if (widget.withParent && isFemale) {
      fields.add(_phoneValidationField(model));
    }

    fields.addAll(<FirstValidationErrorField>[
      _validationField(
        fieldName: IndividualValidationField.height,
        title: LocaleKeys.tall,
        value: model.height,
        validator: (value) => Validators.validateNumeric(
          value,
          min: 75,
          max: 250,
          fieldTitle: LocaleKeys.tall.tr(),
        ),
      ),
      _validationField(
        fieldName: IndividualValidationField.weight,
        title: LocaleKeys.weight,
        value: model.weight,
        validator: (value) => Validators.validateNumeric(
          value,
          min: 30,
          max: 300,
          fieldTitle: LocaleKeys.weight.tr(),
        ),
      ),
      _validationField(
        fieldName: IndividualValidationField.currentJob,
        title: LocaleKeys.currentJob,
        value: model.currentJob,
        validator: (value) => Validators.validateString(
          value,
          min: 3,
          max: 100,
          fieldTitle: LocaleKeys.currentJob.tr(),
        ),
      ),
    ]);

    if (widget.withParent) {
      fields.add(_validationField(
        fieldName: IndividualValidationField.age,
        title: LocaleKeys.age,
        value: model.age?.toString(),
        validator: (value) => Validators.validateAge(
          value,
          fieldTitle: LocaleKeys.age.tr(),
          isRequired: true,
        ),
      ));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.bio,
      title: LocaleKeys.quickBrief,
      value: model.bio,
      validator: (value) => Validators.validateString(
        value,
        min: 3,
        max: 1000,
        fieldTitle: LocaleKeys.quickBrief.tr(),
      ),
    ));

    if (model.hasChildren == true) {
      fields.addAll(<FirstValidationErrorField>[
        _validationField(
          fieldName: IndividualValidationField.childrenNumber,
          title: LocaleKeys.childrenNumber,
          value: model.numOfChildren?.toString(),
          validator: (value) => Validators.validateInteger(
            value,
            min: 0,
            max: 100,
            fieldTitle: LocaleKeys.childrenNumber.tr(),
          ),
        ),
        _validationField(
          fieldName: IndividualValidationField.childCustody,
          title: LocaleKeys.nursery,
          value: model.childCustody?.title,
          validator: Validators.validateEmpty,
        ),
      ]);
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.prohibitedThings,
      title: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
      value: model.prohibitedThings,
      validator: (value) => Validators.validateString(
        value,
        min: 3,
        max: 1000,
        fieldTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant.tr(),
      ),
    ));

    fields.add(_validationField(
      fieldName: IndividualValidationField.city,
      title: LocaleKeys.city,
      value: model.cityId?.name,
      validator: Validators.validateEmpty,
    ));

    if (isFemale && widget.withParent) {
      fields.add(_preferredResidenceValidationField(model));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.educationLevel,
      title: LocaleKeys.educationalQualification,
      value: model.educationLevel,
      validator: (value) => Validators.validateString(
        value,
        fieldTitle: LocaleKeys.educationalQualification.tr(),
      ),
    ));

    if (isFemale && !widget.withParent) {
      fields.add(_preferredResidenceValidationField(model));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.healthConditions,
      title: LocaleKeys.diseasesIfExists,
      value: model.healthConditions,
      validator: (value) => Validators.validateString(
        value,
        min: 3,
        max: 1000,
        isRequired: false,
        fieldTitle: LocaleKeys.diseasesIfExists.tr(),
      ),
    ));

    if (isFemale) {
      fields.add(_validationField(
        fieldName: IndividualValidationField.hijab,
        title: LocaleKeys.areYouWaringHijab,
        value: (model as FemaleModel).hijab?.title,
        validator: Validators.validateEmpty,
      ));
    }

    fields.add(_validationField(
      fieldName: IndividualValidationField.religiousCommitment,
      title: LocaleKeys.degreeOfCommitment,
      value: model.religiousCommitment?.title,
      validator: Validators.validateEmpty,
    ));

    if (widget.showConditionsAndTerms) {
      fields.add(_validationField(
        fieldName: IndividualValidationField.termsAcceptance,
        title: LocaleKeys.conditionsAndTerms,
        value: _conditionsAccepted.toString(),
        validator: (_) => _conditionsAccepted
            ? null
            : LocaleKeys.pleaseAcceptTheConditionsAndTerms,
      ));
    }

    return fields;
  }

  FirstValidationErrorField _phoneValidationField(
    IndividualUserModel model,
  ) {
    return _validationField(
      fieldName: IndividualValidationField.phone,
      title: LocaleKeys.phoneNumber,
      value: model.phone,
      validator: Validators.validatePhone,
    );
  }

  FirstValidationErrorField _preferredResidenceValidationField(
    IndividualUserModel model,
  ) {
    return _validationField(
      fieldName: IndividualValidationField.preferredResidence,
      title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
      value: (model as FemaleModel).preferredResidenceAfterMarriage,
      validator: (value) => Validators.validateString(
        value,
        min: 3,
        max: 1000,
        fieldTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage.tr(),
      ),
    );
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
                validationFieldKeys: _validationFieldKeys,
                validationFields: _validationFields,
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
                onTermsAcceptanceChanged: (bool isAccepted) =>
                    _conditionsAccepted = isAccepted,
                onBackPressed: _goToGenderPage,
                onSubmitPressed: _submit,
              ),
            )
          : _ChildDataForm(
              formKey: _formKey,
              validationFieldKeys: _validationFieldKeys,
              validationFields: _validationFields,
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
              onTermsAcceptanceChanged: (bool isAccepted) =>
                  _conditionsAccepted = isAccepted,
              onBackPressed: _goToGenderPage,
              onSubmitPressed: _submit,
            ),
    );
  }
}
