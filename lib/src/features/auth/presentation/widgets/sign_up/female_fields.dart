import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_dropinity.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/kinship.dart';
import '../../cubits/personal_data_cubit.dart';
import '../../data/auth_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'radio_widget.dart';
import 'shared_form_fields.dart';

class FemaleFields extends StatefulWidget {
  final bool withParent;
  final IndividualUserModel? initialValue;
  final FormMode mode;
  final void Function(IndividualUserModel data) onChangeFemaleData;
  const FemaleFields({
    super.key,
    this.initialValue,
    required this.withParent,
    required this.onChangeFemaleData,
    this.mode = FormMode.all,
  });

  @override
  State<FemaleFields> createState() => _FemaleFieldsState();
}

class _FemaleFieldsState extends State<FemaleFields> {

  late TextEditingController _nameCont;
  late TextEditingController _liveAfterMarryCont;
  // late TextEditingController _parentNameCont;
  // late TextEditingController _parentNumberCont;
  late TextEditingController _phoneCont;
  // late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;

  final ValueNotifier<String?> wearingHijab = ValueNotifier(null);
  Answer? acceptsPolygamy;


  // void _wearingHijabListener(){
  //   if(wearingHijab.value.isNull || wearingHijab.value!.isEmpty){
  //     degreeOfCommitment = null;
  //     _listenToData(asFemale.copyWith(religiousCommitment: null));
  //   }
  // }
  //
  // void _listenToWearingHijab(){
  //   wearingHijab.addListener(_wearingHijabListener);
  // }

  late IndividualUserModel femaleFields;
  void _init() {
    femaleFields = FemaleModel.initial();
    _listenToData(femaleFields.copyWith(
        gender: GenderValueShape(userGender: UserGender.female)
    ));
  }

  @override
  void initState() {
    _init();
    _nameCont = TextEditingController(text: widget.initialValue?.name);
    _liveAfterMarryCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.preferredResidenceAfterMarriage);
    // _parentNameCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.guardianName);
    // _parentNumberCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.guardianPhone);
    _phoneCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.phone);
    // _identifyNumberCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.identityNumber);
    _ageCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.age.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _liveAfterMarryCont.dispose();
    // _parentNameCont.dispose();
    // _parentNumberCont.dispose();
    _phoneCont.dispose();
    // _identifyNumberCont.dispose();
    _ageCont.dispose();
    super.dispose();
  }

  void _listenToData(IndividualUserModel updatedModel) {
    femaleFields = updatedModel;
    widget.onChangeFemaleData.call(femaleFields);
  }

  FemaleModel get asFemale => femaleFields as FemaleModel;
  final _formKey = GlobalKey<FormState>();

  Widget _nameField() => SignUpTextField(
        upperTitle: LocaleKeys.name,
        title: LocaleKeys.pleaseEnterName,
        controller: _nameCont,
        onChanged: (val) => _listenToData(asFemale.copyWith(name: val)),
        validator: (v) => Validators.validateName(v, fieldTitle: LocaleKeys.name.tr()),
      );

  Widget _phoneField() => SignUpTextField(
        upperTitle: LocaleKeys.phoneNumber,
        title: LocaleKeys.pleaseEnterTheNumber,
        controller: _phoneCont,
        onChanged: (value) => _listenToData(asFemale.copyWith(phone: value)),
        validator: Validators.validatePhone,
        inputType: TextInputType.number,
      );

  Widget _ageField() => SignUpTextField(
        upperTitle: LocaleKeys.age,
        title: LocaleKeys.pleaseEnterYourAge,
        onChanged: (value) =>
            _listenToData(asFemale.copyWith(age: int.parse(value!))),
        controller: _ageCont,
        inputType: TextInputType.number,
        validator: (v) => Validators.validateAge(v, fieldTitle: LocaleKeys.age.tr(), isRequired: true),
      );

  Widget _liveAfterMarryField() => SignUpTextField(
        upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
        title: LocaleKeys.pleaseEnterHome,
        controller: _liveAfterMarryCont,
        onChanged: (value) => _listenToData(
            asFemale.copyWith(preferredResidenceAfterMarriage: value)),
      );

  Widget _polygamyField() => RadioWidget<Answer>(
        initialValue: (widget.initialValue as FemaleModel?)?.acceptsPolygamy?.toAnswer,
        title: LocaleKeys.doYouAcceptPolygamy,
        onSubmit: (result) {
          acceptsPolygamy = result;
          _listenToData(asFemale.copyWith(acceptsPolygamy: acceptsPolygamy.toBool));
        },
        values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      );

  Widget _hijabField() => AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
        initialValue: (widget.initialValue as FemaleModel?)?.hijab,
        hint: LocaleKeys.areYouWaringHijab,
        title: LocaleKeys.areYouWaringHijab,
        asyncCall: (BuildContext ctx, int page) async =>
            await AuthData.getPersonalData(ApiConstants.hijabTypes),
        getLabel: (TitleValueShape element) => element.title,
        onChanged: (value) {
          wearingHijab.value = value?.value;
          _listenToData(asFemale.copyWith(
              hijab: TitleValueShape.fromSingleLabel(wearingHijab.value)));
        },
        cacheKey: 'hijab_types',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => TitleValueShape.fromJson(json),
      );

  void _allInsertsWithParent(List<Widget> children) {
    children
      ..insert(2, _phoneField())
      ..insert(6, _ageField())
      ..insert(15, _liveAfterMarryField())
      ..insert(17, _polygamyField())
      ..insert(21, _hijabField())
      ..insert(0, _nameField());
  }

  void _allInsertsIndividual(List<Widget> children) {
    children
      ..insert(15, _liveAfterMarryField())
      ..insert(18, _polygamyField())
      ..insert(21, _hijabField());
  }

  void _requiredInserts(List<Widget> children) {
    children
      ..insert(0, _nameField())
      ..insert(2, _phoneField())
      ..add(_ageField());
  }

  void _optionalInserts(List<Widget> children) {
    children
      ..insert(11, _liveAfterMarryField())
      ..insert(14, _polygamyField())
      ..insert(17, _hijabField());
  }

  @override
  Widget build(BuildContext context) {
    return SharedFormFields<FemaleModel>(
      restorationId: 'female_fields',
      initialValue: widget.initialValue,
      mode: widget.mode,
      onChanged: (data) => _listenToData(asFemale.merge(data.copyWith())),
      onInitData: widget.withParent ? _allInsertsWithParent : _allInsertsIndividual,
      onInitRequired: widget.withParent ? _requiredInserts : null,
      onInitOptional: _optionalInserts,
    );
  }
}