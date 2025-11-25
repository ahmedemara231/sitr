import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_dropinity.dart';
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
  final bool withParent;
  final IndividualUserModel? initialValue;
  final void Function(IndividualUserModel data) onChangeFemaleData;
  const FemaleFields({
    super.key,
    this.initialValue,
    required this.withParent,
    required this.onChangeFemaleData,
  });

  @override
  State<FemaleFields> createState() => _FemaleFieldsState();
}

class _FemaleFieldsState extends State<FemaleFields> {

  late TextEditingController _nameCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
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
        gender: Gender(userType: UserType.female)
    ));
  }

  @override
  void initState() {
    _init();
    _nameCont = TextEditingController(text: widget.initialValue?.name);
    _liveAfterMarryCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.preferredResidenceAfterMarriage);
    _parentNameCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.guardianName);
    _parentNumberCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.guardianPhone);
    _phoneCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.phone);
    _identifyNumberCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.identityNumber);
    _ageCont = TextEditingController(text: (widget.initialValue as FemaleModel?)?.age.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    super.dispose();
  }

  void _listenToData(IndividualUserModel updatedModel) {
    femaleFields = updatedModel;
    widget.onChangeFemaleData.call(femaleFields);
  }

  FemaleModel get asFemale => femaleFields as FemaleModel;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    switch (widget.withParent) {
      case false:
        return SharedFormFields<FemaleModel>(
          restorationId: 'female_fields',
          initialValue: widget.initialValue,
          onChanged: (data) => _listenToData(asFemale.merge(data.copyWith())),
          // onChanged: (data) => _listenToData(asFemale.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children..insert(
              15,
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(preferredResidenceAfterMarriage: value)),
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
            AppDropinityLocal<TitleValueShape>(
              initialValue: (widget.initialValue as FemaleModel?)?.hijab?.title,
              hint: LocaleKeys.areYouWaringHijab,
              title: LocaleKeys.areYouWaringHijab,
              values: EnumsData.hijab.data,
              getLabel: (TitleValueShape element) => element.title,
              onChanged: (value) {
                wearingHijab.value = value.value;
                _listenToData(asFemale.copyWith(hijab: TitleValueShape.fromSingleLabel(wearingHijab.value)));
              },
            ),

              SignUpTextField(
                upperTitle: LocaleKeys.parentName,
                title: LocaleKeys.pleaseEnterName,
                controller: _parentNameCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianName: value)),

                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.parentNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _parentNumberCont,
                inputType: TextInputType.phone,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianPhone: value)),
                // validator: Validators.validateEmpty,
              ),
            AppDropinity<List<Kinship>, Kinship>.withApiRequest(
              initialValue: (widget.initialValue as FemaleModel?)?.guardianRelation?.value,
              hint: LocaleKeys.kinship,
              title: LocaleKeys.kinship,
              asyncCall: (BuildContext ctx, int page) async => await AuthData.getKinships(),
              getLabel: (Kinship element) => element.value,
              onChanged: (value) => _listenToData(asFemale.copyWith(guardianRelation: value)),
            ),
            ]),
        );

      default:
        return SharedFormFields<FemaleModel>(
          restorationId: 'female_fields',
          initialValue: widget.initialValue,
          onChanged: (data) => _listenToData(asFemale.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children..insert(2, 
            SignUpTextField(
              upperTitle: LocaleKeys.phoneNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _phoneCont,
              onChanged: (value) => _listenToData(asFemale.copyWith(phone: value)),
              // validator: Validators.validatePhone,
              inputType: TextInputType.number,
            ),
          )..insertAll(6, [
            SignUpTextField(
              upperTitle: LocaleKeys.age,
              title: LocaleKeys.pleaseEnterYourAge,
              onChanged: (value) => _listenToData(asFemale.copyWith(age: int.parse(value!))),
              controller: _ageCont,
              inputType: TextInputType.number,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.identifyNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _identifyNumberCont,
              onChanged: (value) => _listenToData(asFemale.copyWith(identityNumber: value)),
              inputType: TextInputType.number,
              // validator: Validators.validateEmpty,
            ),
          ])
            ..insertAll(15, [
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(preferredResidenceAfterMarriage: value)),
                // validator: Validators.validateEmpty,
              ),
            ])
            ..insertAll(17, [
              RadioWidget<Answer>(
                initialValue: (widget.initialValue as FemaleModel?)?.acceptsPolygamy?.toAnswer,
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
              AppDropinityLocal<TitleValueShape>(
                initialValue: (widget.initialValue as FemaleModel?)?.hijab?.title,
                hint: LocaleKeys.areYouWaringHijab,
                title: LocaleKeys.areYouWaringHijab,
                values: EnumsData.hijab.data,
                getLabel: (TitleValueShape element) => element.title,
                onChanged: (value) {
                  wearingHijab.value = value?.value;
                  _listenToData(asFemale.copyWith(hijab: TitleValueShape.fromSingleLabel(wearingHijab.value)));
                },
              ),


              SignUpTextField(
                upperTitle: LocaleKeys.parentName,
                title: LocaleKeys.pleaseEnterName,
                controller: _parentNameCont,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianName: value)),

                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.parentNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _parentNumberCont,
                inputType: TextInputType.phone,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianPhone: value)),
                // validator: Validators.validateEmpty,
              ),

              AppDropinity<List<Kinship>, Kinship>.withApiRequest(
                initialValue: (widget.initialValue as FemaleModel?)?.guardianRelation?.value,
                hint: LocaleKeys.kinship,
                title: LocaleKeys.kinship,
                asyncCall: (BuildContext ctx, int page) async => await AuthData.getKinships(),
                getLabel: (Kinship element) => element.value,
                onChanged: (value) => _listenToData(asFemale.copyWith(guardianRelation: value)),
              ),

            ])
            ..insert(
              0,
              SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameCont,
                onChanged: (val) => _listenToData(
                    asFemale.copyWith(name: val)
                ),
                // validator: Validators.validateEmpty,
              ),
            ),
        );
    }
  }
}