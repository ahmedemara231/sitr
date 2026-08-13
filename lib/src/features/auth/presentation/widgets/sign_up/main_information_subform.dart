part of '../../../imports.dart';

class _MainInformationSubform extends StatefulWidget {
  final IndividualUserModel model;
  final bool withParent;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final void Function(IndividualUserModel model) onChanged;

  const _MainInformationSubform({
    required this.model,
    required this.withParent,
    required this.validationFieldKeys,
    required this.onChanged,
  });

  @override
  State<_MainInformationSubform> createState() =>
      _MainInformationSubformState();
}

class _MainInformationSubformState extends State<_MainInformationSubform> {
  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model.name);
    _nicknameController = TextEditingController(text: widget.model.nickName);
    _phoneController = TextEditingController(text: widget.model.phone);
    _ageController = TextEditingController(
      text: widget.model.age?.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _update(IndividualUserModel model) => widget.onChanged(model);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        if (widget.withParent)
          SelectImageWidget(
            initialValue: widget.model.avatar,
            onSelectImage: (File? image) =>
                _update(widget.model.copyWith(avatar: image)),
          ),
        if (widget.withParent)
          SignUpTextField(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.name,
            ),
            upperTitle: LocaleKeys.name,
            title: LocaleKeys.pleaseEnterName,
            controller: _nameController,
            onChanged: (String? value) =>
                _update(widget.model.copyWith(name: value)),
            validator: (String? value) => Validators.validateName(
              value,
              fieldTitle: LocaleKeys.name,
            ),
          ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.nickname,
          ),
          upperTitle: LocaleKeys.nickname,
          title: LocaleKeys.pleaseEnterYourName,
          controller: _nicknameController,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(nickName: value)),
          validator: (String? value) => Validators.validateName(
            value,
            fieldTitle: LocaleKeys.nickname,
          ),
        ),
        if (widget.withParent)
          SignUpTextField(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.phone,
            ),
            upperTitle: LocaleKeys.phoneNumber,
            title: LocaleKeys.pleaseEnterTheNumber,
            controller: _phoneController,
            inputType: TextInputType.phone,
            onChanged: (String? value) =>
                _update(widget.model.copyWith(phone: value)),
            validator: Validators.validatePhone,
          ),
        if (widget.withParent)
          SignUpTextField(
            key: widget.validationFieldKeys.get(
              IndividualValidationField.age,
            ),
            upperTitle: LocaleKeys.age,
            title: LocaleKeys.pleaseEnterYourAge,
            controller: _ageController,
            inputType: TextInputType.number,
            onChanged: (String? value) => _update(
              widget.model.copyWith(age: int.tryParse(value ?? '')),
            ),
            validator: (String? value) => Validators.validateAge(
              value,
              fieldTitle: LocaleKeys.age,
              isRequired: true,
            ),
          ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.maritalStatus,
          ),
          listHeight: 100.h,
          hint: LocaleKeys.pleaseEnterMartialStatus,
          initialValue: widget.model.maritalStatus,
          title: LocaleKeys.maritalStatus,
          asyncCall: (BuildContext context, int page) async =>
              await AuthData.getPersonalData(ApiConstants.maritalStatuses),
          getLabel: (TitleValueShape value) => value.title,
          onChanged: (TitleValueShape value) {
            IndividualUserModel updatedModel =
                widget.model.copyWith(maritalStatus: value);
            if (value.value == 'single') {
              updatedModel = updatedModel.copyWith(
                hasChildren: false,
                clearNumOfChildren: true,
                clearChildCustody: true,
              );
            }
            _update(updatedModel);
          },
          validator: (TitleValueShape? value) =>
              Validators.validateEmpty(value?.title),
          cacheKey: 'marital_statuses',
          cacheToJson: (TitleValueShape value) => value.toJson(),
          cacheFromJson: (Map<String, dynamic> json) =>
              TitleValueShape.fromJson(json),
        ),
      ],
    );
  }
}
