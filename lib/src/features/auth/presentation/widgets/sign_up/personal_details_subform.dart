part of '../../../imports.dart';

class _PersonalDetailsSubform extends StatefulWidget {
  final IndividualUserModel model;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final void Function(IndividualUserModel model) onChanged;

  const _PersonalDetailsSubform({
    required this.model,
    required this.validationFieldKeys,
    required this.onChanged,
  });

  @override
  State<_PersonalDetailsSubform> createState() =>
      _PersonalDetailsSubformState();
}

class _PersonalDetailsSubformState extends State<_PersonalDetailsSubform> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _currentJobController;
  late final TextEditingController _bioController;
  late final TextEditingController _educationController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.model.height);
    _weightController = TextEditingController(text: widget.model.weight);
    _currentJobController =
        TextEditingController(text: widget.model.currentJob);
    _bioController = TextEditingController(text: widget.model.bio);
    _educationController =
        TextEditingController(text: widget.model.educationLevel);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _currentJobController.dispose();
    _bioController.dispose();
    _educationController.dispose();
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
            IndividualValidationField.height,
          ),
          upperTitle: LocaleKeys.tall,
          title: LocaleKeys.pleaseEnterTheTall,
          controller: _heightController,
          inputType: TextInputType.number,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(height: value)),
          validator: (String? value) => Validators.validateNumeric(
            value,
            min: 75,
            max: 250,
            fieldTitle: LocaleKeys.tall,
          ),
        ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.weight,
          ),
          upperTitle: LocaleKeys.weight,
          title: LocaleKeys.pleaseEnterTheWeight,
          controller: _weightController,
          inputType: TextInputType.number,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(weight: value)),
          validator: (String? value) => Validators.validateNumeric(
            value,
            min: 30,
            max: 300,
            fieldTitle: LocaleKeys.weight,
          ),
        ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.currentJob,
          ),
          upperTitle: LocaleKeys.currentJob,
          title: LocaleKeys.pleaseEnterTheCurrentJob,
          controller: _currentJobController,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(currentJob: value)),
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 100,
            fieldTitle: LocaleKeys.currentJob,
          ),
        ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(IndividualValidationField.bio),
          upperTitle: LocaleKeys.quickBrief,
          title: LocaleKeys.pleaseEnterTheBrief,
          controller: _bioController,
          inputType: TextInputType.multiline,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(bio: value)),
          validator: (String? value) => Validators.validateString(
            value,
            min: 3,
            max: 1000,
            fieldTitle: LocaleKeys.quickBrief,
          ),
        ),
        AppDropinity<List<CityModel>, CityModel>.withApiRequest(
          key: widget.validationFieldKeys.get(IndividualValidationField.city),
          initialValue: widget.model.cityId,
          hint: LocaleKeys.pleaseEnterTheCity,
          title: LocaleKeys.city,
          asyncCall: (BuildContext context, int page) async =>
              await AuthData.getCities(),
          getLabel: (CityModel city) => city.name ?? '',
          onChanged: (CityModel city) =>
              _update(widget.model.copyWith(cityId: city)),
          validator: (CityModel? city) => Validators.validateEmpty(city?.name),
          cacheKey: 'cities',
          cacheToJson: (CityModel city) => city.toJson(),
          cacheFromJson: (Map<String, dynamic> json) =>
              CityModel.fromJson(json),
        ),
        SignUpTextField(
          key: widget.validationFieldKeys.get(
            IndividualValidationField.educationLevel,
          ),
          upperTitle: LocaleKeys.educationalQualification,
          title: LocaleKeys.pleaseEnterTheEducationalQualification,
          controller: _educationController,
          onChanged: (String? value) =>
              _update(widget.model.copyWith(educationLevel: value)),
          validator: (String? value) => Validators.validateString(
            value,
            fieldTitle: LocaleKeys.educationalQualification,
          ),
        ),
      ],
    );
  }
}
