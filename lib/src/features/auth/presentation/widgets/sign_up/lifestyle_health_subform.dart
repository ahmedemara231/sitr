part of '../../../imports.dart';

class _LifestyleHealthSubform extends StatefulWidget {
  final IndividualUserModel model;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final void Function(IndividualUserModel model) onChanged;

  const _LifestyleHealthSubform({
    required this.model,
    required this.validationFieldKeys,
    required this.onChanged,
  });

  @override
  State<_LifestyleHealthSubform> createState() =>
      _LifestyleHealthSubformState();
}

class _LifestyleHealthSubformState extends State<_LifestyleHealthSubform> {
  late final TextEditingController _healthConditionsController;

  @override
  void initState() {
    super.initState();
    _healthConditionsController =
        TextEditingController(text: widget.model.healthConditions);
  }

  @override
  void dispose() {
    _healthConditionsController.dispose();
    super.dispose();
  }

  void _update(IndividualUserModel model) => widget.onChanged(model);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.healthConditions,
          ),
          upperTitle: LocaleKeys.diseasesIfExists,
          title: LocaleKeys.pleaseEnterTheDiseases,
          controller: _healthConditionsController,
          inputType: TextInputType.multiline,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(healthConditions: value)),
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            isRequired: false,
            fieldTitle: LocaleKeys.diseasesIfExists,
          ),
        ),
        RadioWidget<Languages>(
          initialValue: widget.model.chatLang?.toLang(),
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (Languages language) => _update(
            widget.model.copyWith(chatLang: language.languageCode),
          ),
          values: Languages.values,
          titleBuilder: (int index) =>
              AppText(Languages.values[index].translate),
        ),
        RadioWidget<Answer>(
          initialValue: widget.model.isSmoker?.toAnswer,
          title: LocaleKeys.areYouSmoke,
          onSubmit: (Answer answer) =>
              _update(widget.model.copyWith(isSmoker: answer.toBool)),
          values: Answer.values,
          titleBuilder: (int index) => AppText(Answer.values[index].translate),
        ),
        RadioWidget<Answer>(
          initialValue: widget.model.tribeAffiliation?.toAnswer,
          title: LocaleKeys.doYouBelongToATribe,
          onSubmit: (Answer answer) => _update(
            widget.model.copyWith(tribeAffiliation: answer.toBool),
          ),
          values: Answer.values,
          titleBuilder: (int index) => AppText(Answer.values[index].translate),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100.h,
          hint: LocaleKeys.pleaseEnterSkinColor,
          initialValue: widget.model.skinColor,
          title: LocaleKeys.skinColor,
          asyncCall: (BuildContext context, int page) async =>
              await AuthData.getPersonalData(ApiConstants.skinColors),
          getLabel: (TitleValueShape value) => value.title,
          onChanged: (TitleValueShape value) => _update(
            widget.model.copyWith(
              skinColor: TitleValueShape.fromSingleLabel(value.value),
            ),
          ),
          cacheKey: 'skin_colors',
          cacheToJson: (TitleValueShape value) => value.toJson(),
          cacheFromJson: (Map<String, dynamic> json) =>
              TitleValueShape.fromJson(json),
        ),
      ],
    );
  }
}
