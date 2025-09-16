import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../models/complete_profile/female_body.dart';
import '../../../models/dowry.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../enums/answer.dart';
import '../../enums/hijab_and_commitment.dart';
import '../shared/text_field.dart';
import 'dowry_widget.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';
import 'shared_form_fields.dart';

class FemaleFields extends StatefulWidget {
  final UserType? secondaryUserType;
  final void Function(SharedFormFieldModel data) onFinishFemaleData;
  const FemaleFields({super.key,
    required this.secondaryUserType,
    required this.onFinishFemaleData,
  });

  @override
  State<FemaleFields> createState() => _FemaleFieldsState();
}

class _FemaleFieldsState extends State<FemaleFields> {

  SharedFormFieldModel sharedFormFieldModel = SharedFormFieldModel.initial();

  void _init(){
    switch(widget.secondaryUserType){
      case null:
        sharedFormFieldModel = FemaleCompleteProfileBody.initial();

      default:
        sharedFormFieldModel = FemaleParentCompleteProfileBody.initial();
    }
  }

  late TextEditingController _nameCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;
  late TextEditingController _kinshipCont;
  late TextEditingController _dowryMinCont;
  late TextEditingController _dowryMaxCont;

  Answer? wearingHijab;
  Answer? acceptsPolygamy;
  String? degreeOfCommitment;

  @override
  void initState() {
    _init();
    _nameCont = TextEditingController();
    _liveAfterMarryCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    _kinshipCont = TextEditingController();
    _dowryMinCont = TextEditingController();
    _dowryMaxCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _kinshipCont.dispose();
    _dowryMinCont.dispose();
    _dowryMaxCont.dispose();
    super.dispose();
  }

  void _listenToData(SharedFormFieldModel updatedModel) {
    sharedFormFieldModel = updatedModel;
    widget.onFinishFemaleData.call(sharedFormFieldModel);
  }


  FemaleCompleteProfileBody get asFemaleCompleteProfileBody{
    return sharedFormFieldModel as FemaleCompleteProfileBody;
  }

  FemaleParentCompleteProfileBody get asFemaleParentCompleteProfileBody{
    return sharedFormFieldModel as FemaleParentCompleteProfileBody;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    switch(widget.secondaryUserType){
      case null:
        return SharedFormFields(
          sharedFormFieldModel: sharedFormFieldModel,
          restorationId: 'female_fields',
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) => children..insertAll(11, [
            DowryWidget(onSelect: (from, to) {
              log('message: $from');
              _listenToData(asFemaleCompleteProfileBody.copyWith(
                  dowry: Dowry(from: from, to: to)
              ));
              // _dowryMinCont.text = from;
              // _dowryMaxCont.text = to;
            }),
          ])..insert(15,
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(liveAfterMarry: _liveAfterMarryCont.text)),
              // validator: Validators.validateEmpty,
            ),
          )..insert(18,
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) {
                  acceptsPolygamy = result;
                  _listenToData(asFemaleCompleteProfileBody.copyWith(doYouAcceptPolygamy: acceptsPolygamy.toBool));
                },
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),
          )..insertAll(21, [
            RadioWidget<Answer>(
                title: LocaleKeys.areYouWaringHijab,
                onSubmit: (result) {
                  setState(() => wearingHijab = result);
                  _listenToData(asFemaleCompleteProfileBody.copyWith(wearingHijab: wearingHijab.toBool));
                },
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

            // DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            if(wearingHijab?.isYes?? false)
              DropDownTextField<Commitment>(
                hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                values: Commitment.values,
                  title: LocaleKeys.degreeOfCommitment,
                  itemBuilder: (v) => AppText(v.translate),
                  onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(degreeOfCommitment: value?.name)),
                  // onChanged: (val) => degreeOfCommitment = val ?? ''
              ),

            SignUpTextField(
              upperTitle: LocaleKeys.parentName,
              title: LocaleKeys.pleaseEnterName,
              controller: _parentNameCont,
              onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(parentName: _parentNameCont.text)),

              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.parentNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _parentNumberCont,
              inputType: TextInputType.phone,
              onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(parentNumber: _parentNumberCont.text)),
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.kinship,
              title: LocaleKeys.pleaseEnterTheKinship,
              controller: _kinshipCont,
              onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(kinship: _kinshipCont.text)),
              // validator: Validators.validateEmpty,
            ),
          ]),
        );

      default:
        return SharedFormFields(
          sharedFormFieldModel: sharedFormFieldModel,
          restorationId: 'female_fields',
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) => children..insertAll(11, [
            DowryWidget(onSelect: (from, to) {
              _listenToData(asFemaleParentCompleteProfileBody.copyWith(dowry: Dowry(from: from, to: to)));
              // _dowryMinCont.text = from;
              // _dowryMaxCont.text = to;
            }),

          ])..insertAll(15, [
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              inputType: TextInputType.phone,
              onChanged: (value) => _listenToData(asFemaleParentCompleteProfileBody.copyWith(liveAfterMarry: _liveAfterMarryCont.text)),
              // validator: Validators.validateEmpty,
            ),
          ])..insertAll(17, [
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) {
                  acceptsPolygamy = result;
                  _listenToData(asFemaleParentCompleteProfileBody.copyWith(doYouAcceptPolygamy: acceptsPolygamy.toBool));
                },
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

          ])..insertAll(21, [

            RadioWidget<Answer>(
                title: LocaleKeys.areYouWaringHijab,
                onSubmit: (result) => setState(() {
                  wearingHijab = result;
                  _listenToData(asFemaleParentCompleteProfileBody.copyWith(wearingHijab: wearingHijab.toBool));
                }),
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

            // DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            if(wearingHijab?.isYes?? false)
              DropDownTextField<String>(
                hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                  values: Commitment.values.map((e) => e.translate).toList(),
                  title: LocaleKeys.degreeOfCommitment,
                  onChanged: (val) =>
                      _listenToData(asFemaleParentCompleteProfileBody.copyWith(degreeOfCommitment: val))
              ),
          ])..insert(0, SignUpTextField(
            upperTitle: LocaleKeys.name,
            title: LocaleKeys.pleaseEnterName,
            controller: _nameCont,
            onChanged: (val) => _listenToData(asFemaleParentCompleteProfileBody.copyWith(name: _nameCont.text)),
            // validator: Validators.validateEmpty,
          ),),
        );
    }
  }
}