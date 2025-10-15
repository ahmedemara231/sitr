import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/kinship.dart';
import '../../data/auth_data.dart';
import '../../data/enums_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';
import 'shared_form_fields.dart';

class FemaleFields extends StatefulWidget {
  final UserType? secondaryUserType;
  final void Function(UserModel data) onFinishFemaleData;
  const FemaleFields({
    super.key,
    required this.secondaryUserType,
    required this.onFinishFemaleData,
  });

  @override
  State<FemaleFields> createState() => _FemaleFieldsState();
}

class _FemaleFieldsState extends State<FemaleFields> {

  late UserModel femaleFields;

  void _init() => femaleFields = FemaleModel.initial();

  late TextEditingController _nameCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;
  late TextEditingController _kinshipCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;

  final ValueNotifier<String?> wearingHijab = ValueNotifier(null);
  Answer? acceptsPolygamy;
  String? degreeOfCommitment;

  @override
  void initState() {
    _init();
    _listenToWearingHijab();
    _nameCont = TextEditingController();
    _liveAfterMarryCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    _kinshipCont = TextEditingController();
    _phoneCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _ageCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _kinshipCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    super.dispose();
  }

  void _listenToData(UserModel updatedModel) {
    femaleFields = updatedModel;
    widget.onFinishFemaleData.call(femaleFields);
  }

  FemaleModel get asFemale {
    return femaleFields as FemaleModel;
  }

  final _formKey = GlobalKey<FormState>();

  void _wearingHijabListener(){
    if(wearingHijab.value.isNull || wearingHijab.value!.isEmpty){
      degreeOfCommitment = null;
      _listenToData(asFemale.copyWith(religiousCommitment: null));
    }
  }

  void _listenToWearingHijab(){
    wearingHijab.addListener(_wearingHijabListener);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.secondaryUserType) {
      case null:
        return SharedFormFields<FemaleModel>(
          restorationId: 'female_fields',
          onFinished: (data) => _listenToData(asFemale.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children..insert(
              15,
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(preferredResidenceAfterMarriage: _liveAfterMarryCont.text)),
                // validator: Validators.validateEmpty,
              ),
            )..insert(
              18,
              RadioWidget<Answer>(
                  title: LocaleKeys.doYouAcceptPolygamy,
                  onSubmit: (result) {
                    acceptsPolygamy = result;
                    _listenToData(asFemale.copyWith(acceptsPolygamy: acceptsPolygamy.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),
            )..insertAll(21, [
            DropDownTextField<TitleValueShape>(
              hint: LocaleKeys.areYouWaringHijab,
              values: EnumsData.hijab.data,
              title: LocaleKeys.areYouWaringHijab,
              itemBuilder: (v) => AppText(v.title),
              onChanged: (value) {
                wearingHijab.value = value?.value;
                _listenToData(asFemale.copyWith(hijab: wearingHijab.value));
              },
            ),
            ValueListenableBuilder(
              valueListenable: wearingHijab,
              builder: (context, value, child) => value?.isNotEmpty?? false? DropDownTextField<TitleValueShape>(
                hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                values: EnumsData.religiousCommitment.data,
                title: LocaleKeys.degreeOfCommitment,
                itemBuilder: (v) => AppText(v.title),
                onChanged: (value) => _listenToData(asFemale.copyWith(religiousCommitment: TitleValueShape(title: '', value: value!.value))),
              ) : const SizedBox.shrink(),
            ),

              SignUpTextField(
                upperTitle: LocaleKeys.parentName,
                title: LocaleKeys.pleaseEnterName,
                controller: _parentNameCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianName: _parentNameCont.text)),

                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.parentNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _parentNumberCont,
                inputType: TextInputType.phone,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianPhone: _parentNumberCont.text)),
                // validator: Validators.validateEmpty,
              ),
              DropDownTextField<Kinship>.withApiRequest(
              hint: LocaleKeys.kinship,
              title: LocaleKeys.kinship,
              itemBuilder: (v) => AppText(v.value),
              onChanged: (value) => _listenToData(asFemale.copyWith(guardianRelation: value)),
              request: (BuildContext ctx) async => await AuthData.getKinships()
            ),
            ]),
        );

      default:
        return SharedFormFields<FemaleModel>(
          restorationId: 'female_fields',
          onFinished: (data) => _listenToData(asFemale.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children..insert(2, 
            SignUpTextField(
              upperTitle: LocaleKeys.phoneNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _phoneCont,
              onChanged: (value) => _listenToData(asFemale.copyWith(phone: _phoneCont.text)),
              // validator: Validators.validatePhone,
              inputType: TextInputType.number,
            ),
          )..insertAll(6, [
            SignUpTextField(
              upperTitle: LocaleKeys.age,
              title: LocaleKeys.pleaseEnterYourAge,
              onChanged: (value) => _listenToData(asFemale.copyWith(age: int.parse(_ageCont.text))),
              controller: _ageCont,
              inputType: TextInputType.number,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.identifyNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _identifyNumberCont,
              onChanged: (value) => _listenToData(asFemale.copyWith(identityNumber: _identifyNumberCont.text)),
              inputType: TextInputType.number,
              // validator: Validators.validateEmpty,
            ),
          ])
            ..insertAll(15, [
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(preferredResidenceAfterMarriage: _liveAfterMarryCont.text)),
                // validator: Validators.validateEmpty,
              ),
            ])
            ..insertAll(17, [
              RadioWidget<Answer>(
                  title: LocaleKeys.doYouAcceptPolygamy,
                  onSubmit: (result) {
                    acceptsPolygamy = result;
                    _listenToData(asFemale.copyWith(acceptsPolygamy: acceptsPolygamy.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),
            ])
            ..insertAll(21, [
              DropDownTextField<TitleValueShape>(
                hint: LocaleKeys.areYouWaringHijab,
                values: EnumsData.hijab.data,
                title: LocaleKeys.areYouWaringHijab,
                itemBuilder: (v) => AppText(v.title),
                onChanged: (value) {
                  wearingHijab.value = value?.value;
                  _listenToData(asFemale.copyWith(hijab: wearingHijab.value));
                },
              ),
              ValueListenableBuilder(
                valueListenable: wearingHijab,
                builder: (context, value, child) => value?.isNotEmpty?? false? DropDownTextField<TitleValueShape>(
                  hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                  values: EnumsData.religiousCommitment.data,
                  title: LocaleKeys.degreeOfCommitment,
                  itemBuilder: (v) => AppText(v.title),
                  onChanged: (value) => _listenToData(asFemale.copyWith(religiousCommitment: TitleValueShape(title: '', value: value!.value))),
                ) : const SizedBox.shrink(),
              ),

              SignUpTextField(
                upperTitle: LocaleKeys.parentName,
                title: LocaleKeys.pleaseEnterName,
                controller: _parentNameCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianName: _parentNameCont.text)),

                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.parentNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _parentNumberCont,
                inputType: TextInputType.phone,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianPhone: _parentNumberCont.text)),
                // validator: Validators.validateEmpty,
              ),
              DropDownTextField<Kinship>.withApiRequest(
                  hint: LocaleKeys.kinship,
                  title: LocaleKeys.kinship,
                  itemBuilder: (v) => AppText(v.value),
                  onChanged: (value) => _listenToData(asFemale.copyWith(guardianRelation: value)),
                  request: (BuildContext ctx) async => await AuthData.getKinships()
              ),
            ])
            ..insert(
              0,
              SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameCont,
                onChanged: (val) => _listenToData(
                    asFemale.copyWith(name: _nameCont.text)
                ),
                // validator: Validators.validateEmpty,
              ),
            ),
        );
    }
  }
}