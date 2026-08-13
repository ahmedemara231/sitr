part of '../../../imports.dart';

class _FaithPreferencesSubform extends StatefulWidget {
  final IndividualUserModel model;
  final bool showConditionsAndTerms;
  final bool termsAccepted;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final void Function(IndividualUserModel model) onChanged;
  final void Function(bool isAccepted) onTermsAcceptanceChanged;

  const _FaithPreferencesSubform({
    required this.model,
    required this.showConditionsAndTerms,
    required this.termsAccepted,
    required this.validationFieldKeys,
    required this.onChanged,
    required this.onTermsAcceptanceChanged,
  });

  @override
  State<_FaithPreferencesSubform> createState() =>
      _FaithPreferencesSubformState();
}

class _FaithPreferencesSubformState extends State<_FaithPreferencesSubform> {
  late final TextEditingController _prohibitedThingsController;

  bool get _isFemale => widget.model is FemaleModel;
  FemaleModel get _femaleModel => widget.model as FemaleModel;

  @override
  void initState() {
    super.initState();
    _prohibitedThingsController =
        TextEditingController(text: widget.model.prohibitedThings);
  }

  @override
  void dispose() {
    _prohibitedThingsController.dispose();
    super.dispose();
  }

  void _update(IndividualUserModel model) => widget.onChanged(model);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        RadioWidget<Answer>(
          initialValue: widget.model.isPrayer?.toAnswer,
          title: LocaleKeys.areYouPray,
          onSubmit: (Answer answer) =>
              _update(widget.model.copyWith(isPrayer: answer.toBool)),
          values: Answer.values,
          titleBuilder: (int index) => AppText(Answer.values[index].translate),
        ),
        if (_isFemale)
          AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.hijab,
            ),
            initialValue: _femaleModel.hijab,
            hint: LocaleKeys.areYouWaringHijab,
            title: LocaleKeys.areYouWaringHijab,
            asyncCall: (BuildContext context, int page) async =>
                await AuthData.getPersonalData(ApiConstants.hijabTypes),
            getLabel: (TitleValueShape value) => value.title,
            onChanged: (TitleValueShape value) => _update(
              _femaleModel.copyWith(
                hijab: TitleValueShape.fromSingleLabel(value.value),
              ),
            ),
            validator: (TitleValueShape? value) =>
                Validators.validateEmpty(value?.title),
            cacheKey: 'hijab_types',
            cacheToJson: (TitleValueShape value) => value.toJson(),
            cacheFromJson: (Map<String, dynamic> json) =>
                TitleValueShape.fromJson(json),
          ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.religiousCommitment,
          ),
          listHeight: 100.h,
          hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
          initialValue: widget.model.religiousCommitment,
          title: LocaleKeys.degreeOfCommitment,
          asyncCall: (BuildContext context, int page) async =>
              await AuthData.getPersonalData(
            ApiConstants.religiousCommitments,
          ),
          getLabel: (TitleValueShape value) => value.title,
          onChanged: (TitleValueShape value) => _update(
            widget.model.copyWith(
              religiousCommitment: TitleValueShape.fromSingleLabel(value.value),
            ),
          ),
          validator: (TitleValueShape? value) =>
              Validators.validateEmpty(value?.title),
          cacheKey: 'religious_commitments',
          cacheToJson: (TitleValueShape value) => value.toJson(),
          cacheFromJson: (Map<String, dynamic> json) =>
              TitleValueShape.fromJson(json),
        ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.prohibitedThings,
          ),
          upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
          title: LocaleKeys.pleaseEnterTheThings,
          inputType: TextInputType.multiline,
          controller: _prohibitedThingsController,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(prohibitedThings: value)),
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            fieldTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
          ),
        ),
        if (widget.showConditionsAndTerms)
          ConditionsTermsAcceptance(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.termsAcceptance,
            ),
            initialValue: widget.termsAccepted,
            onAcceptanceChanged: widget.onTermsAcceptanceChanged,
          ),
      ],
    );
  }
}
