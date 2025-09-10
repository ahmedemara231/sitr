import 'package:flutter/material.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../models/complete_profile/female.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../enums/answer.dart';
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
              _dowryMinCont.text = from;
              _dowryMaxCont.text = to;
            }),
          ])..insert(15,
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              // validator: Validators.validateEmpty,
            ),
          )..insert(18,
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) => acceptsPolygamy = result,
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),
          )..insertAll(21, [
            RadioWidget<Answer>(
                title: LocaleKeys.areYouWaringHijab,
                onSubmit: (result) => setState(() => wearingHijab = result),
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

            // DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            if(wearingHijab?.isYes?? false)
              DropDownTextField(
                  title: LocaleKeys.degreeOfCommitment,
                  onChanged: (val) => degreeOfCommitment = val ?? ''
              ),

            SignUpTextField(
              upperTitle: LocaleKeys.parentName,
              title: LocaleKeys.pleaseEnterName,
              controller: _parentNameCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.parentNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _parentNumberCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.kinship,
              title: LocaleKeys.pleaseEnterTheKinship,
              controller: _kinshipCont,
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
              _dowryMinCont.text = from;
              _dowryMaxCont.text = to;
            }),
          ])..insertAll(15, [
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              // validator: Validators.validateEmpty,
            ),
          ])..insertAll(17, [
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) => acceptsPolygamy = result,
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

          ])..insertAll(21, [

            RadioWidget<Answer>(
                title: LocaleKeys.areYouWaringHijab,
                onSubmit: (result) => setState(() => wearingHijab = result),
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

            // DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            if(wearingHijab?.isYes?? false)
              DropDownTextField(title: LocaleKeys.degreeOfCommitment, onChanged: (val) => degreeOfCommitment = val ?? ''),
          ])..insert(0, SignUpTextField(
            upperTitle: LocaleKeys.name,
            title: LocaleKeys.pleaseEnterName,
            controller: _nameCont,
            // validator: Validators.validateEmpty,
          ),),
        );
    }
  }
}