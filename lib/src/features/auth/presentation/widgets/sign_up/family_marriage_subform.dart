part of '../../../imports.dart';

class _FamilyMarriageSubform extends StatefulWidget {
  final IndividualUserModel model;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final void Function(IndividualUserModel model) onChanged;

  const _FamilyMarriageSubform({
    required this.model,
    required this.validationFieldKeys,
    required this.onChanged,
  });

  @override
  State<_FamilyMarriageSubform> createState() => _FamilyMarriageSubformState();
}

class _FamilyMarriageSubformState extends State<_FamilyMarriageSubform> {
  late final TextEditingController _childrenNumberController;
  late final TextEditingController _preferredResidenceController;

  bool get _isFemale => widget.model is FemaleModel;
  FemaleModel get _femaleModel => widget.model as FemaleModel;

  @override
  void initState() {
    super.initState();
    _childrenNumberController = TextEditingController(
      text: widget.model.numOfChildren?.toString(),
    );
    _preferredResidenceController = TextEditingController(
      text: widget.model is FemaleModel
          ? (widget.model as FemaleModel).preferredResidenceAfterMarriage
          : null,
    );
  }

  @override
  void dispose() {
    _childrenNumberController.dispose();
    _preferredResidenceController.dispose();
    super.dispose();
  }

  void _update(IndividualUserModel model) => widget.onChanged(model);

  @override
  Widget build(BuildContext context) {
    final bool canHaveChildren = widget.model.maritalStatus?.value != 'single';

    return Column(
      spacing: 12.h,
      children: [
        if (canHaveChildren)
          RadioWidget<Answer>(
            initialValue: widget.model.hasChildren?.toAnswer,
            title: LocaleKeys.childrenExists,
            onSubmit: (Answer answer) {
              if (answer.isNo) {
                _childrenNumberController.clear();
                _update(
                  widget.model.copyWith(
                    hasChildren: false,
                    clearNumOfChildren: true,
                    clearChildCustody: true,
                  ),
                );
                return;
              }
              _update(widget.model.copyWith(hasChildren: true));
            },
            values: Answer.values,
            titleBuilder: (int index) =>
                AppText(Answer.values[index].translate),
          ),
        if (canHaveChildren && widget.model.hasChildren == true)
          Column(
            spacing: 12.h,
            children: [
              SignUpTextField(
                key: widget.validationFieldKeys.get(
                  IndividualValidationField.childrenNumber,
                ),
                upperTitle: LocaleKeys.childrenNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _childrenNumberController,
                inputType: TextInputType.number,
                onChanged: (String? value) {
                  final int? childrenNumber = int.tryParse(value ?? '');
                  _update(
                    widget.model.copyWith(
                      numOfChildren: childrenNumber,
                      clearNumOfChildren: childrenNumber == null,
                    ),
                  );
                },
                validator: (String? value) => Validators.validateInteger(
                  value,
                  min: 0,
                  max: 100,
                  fieldTitle: LocaleKeys.childrenNumber,
                ),
              ),
              AppDropinity<List<TitleValueShape>,
                  TitleValueShape>.withApiRequest(
                key: widget.validationFieldKeys.get(
                  IndividualValidationField.childCustody,
                ),
                initialValue: widget.model.childCustody,
                hint: LocaleKeys.nursery,
                title: LocaleKeys.nursery,
                asyncCall: (BuildContext context, int page) async =>
                    await AuthData.getPersonalData(
                  ApiConstants.childCustodies,
                ),
                getLabel: (TitleValueShape value) => value.title,
                onChanged: (TitleValueShape value) =>
                    _update(widget.model.copyWith(childCustody: value)),
                validator: (TitleValueShape? value) =>
                    Validators.validateEmpty(value?.title),
                cacheKey: 'child_custodies',
                cacheToJson: (TitleValueShape value) => value.toJson(),
                cacheFromJson: (Map<String, dynamic> json) =>
                    TitleValueShape.fromJson(json),
              ),
            ],
          ),
        RadioWidget<Answer>(
          initialValue: widget.model.wantChildren?.toAnswer,
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (Answer answer) =>
              _update(widget.model.copyWith(wantChildren: answer.toBool)),
          values: Answer.values,
          titleBuilder: (int index) => AppText(Answer.values[index].translate),
        ),
        DowryWidget(
          initialValue: widget.model.dowry,
          onSelect: (Dowry dowry) =>
              _update(widget.model.copyWith(dowry: dowry)),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100.h,
          hint: LocaleKeys.pleaseEnterTheWeddingParty,
          initialValue: widget.model.weddingType,
          title: LocaleKeys.typeOfWeddingParty,
          asyncCall: (BuildContext context, int page) async =>
              await AuthData.getPersonalData(ApiConstants.weddingTypes),
          getLabel: (TitleValueShape value) => value.title,
          onChanged: (TitleValueShape value) => _update(
            widget.model.copyWith(
              weddingType: TitleValueShape.fromSingleLabel(value.value),
            ),
          ),
          cacheKey: 'wedding_types',
          cacheToJson: (TitleValueShape value) => value.toJson(),
          cacheFromJson: (Map<String, dynamic> json) =>
              TitleValueShape.fromJson(json),
        ),
        if (_isFemale)
          SignUpTextField(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.preferredResidence,
            ),
            upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
            title: LocaleKeys.pleaseEnterHome,
            controller: _preferredResidenceController,
            onChanged: (String? value) => _update(
              _femaleModel.copyWith(
                preferredResidenceAfterMarriage: value,
              ),
            ),
            validator: (String? value) => Validators.validateString(
              value,
              min: 3,
              max: 1000,
              fieldTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
            ),
          ),
        if (_isFemale)
          RadioWidget<Answer>(
            initialValue: _femaleModel.acceptsPolygamy?.toAnswer,
            title: LocaleKeys.doYouAcceptPolygamy,
            onSubmit: (Answer answer) => _update(
              _femaleModel.copyWith(acceptsPolygamy: answer.toBool),
            ),
            values: Answer.values,
            titleBuilder: (int index) =>
                AppText(Answer.values[index].translate),
          ),
      ],
    );
  }
}
