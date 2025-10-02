import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../models/complete_profile/female_body.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../data/enums_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';
import 'shared_form_fields.dart';

class FemaleFields extends StatefulWidget {
  final UserType? secondaryUserType;
  final void Function(SharedFormFieldModel data) onFinishFemaleData;
  const FemaleFields({
    super.key,
    required this.secondaryUserType,
    required this.onFinishFemaleData,
  });

  @override
  State<FemaleFields> createState() => _FemaleFieldsState();
}

class _FemaleFieldsState extends State<FemaleFields> {

  late SharedFormFieldModel sharedFormFieldModel;

  void _init() {
    switch (widget.secondaryUserType) {
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

  final ValueNotifier<Answer?> wearingHijab = ValueNotifier(null);
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
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _kinshipCont.dispose();
    super.dispose();
  }

  void _listenToData(SharedFormFieldModel updatedModel) {
    sharedFormFieldModel = updatedModel;
    widget.onFinishFemaleData.call(sharedFormFieldModel);
  }

  FemaleParentCompleteProfileBody get asFemaleParentCompleteProfileBody {
    return sharedFormFieldModel as FemaleParentCompleteProfileBody;
  }

  FemaleCompleteProfileBody get asFemaleCompleteProfileBody {
    return sharedFormFieldModel as FemaleCompleteProfileBody;
  }

  final _formKey = GlobalKey<FormState>();

  void _wearingHijabListener(){
    if(wearingHijab.value.isNo){
      degreeOfCommitment = null;
      _listenToData(asFemaleCompleteProfileBody.copyWith(degreeOfCommitment: null));
    }
  }

  void _listenToWearingHijab(){
    wearingHijab.addListener(_wearingHijabListener);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.secondaryUserType) {
      case null:
        return SharedFormFields<FemaleCompleteProfileBody>(
          restorationId: 'female_fields',
          onFinished: (data) => _listenToData(asFemaleCompleteProfileBody.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children..insert(
              15,
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(liveAfterMarry: _liveAfterMarryCont.text)),
                // validator: Validators.validateEmpty,
              ),
            )..insert(
              18,
              RadioWidget<Answer>(
                  title: LocaleKeys.doYouAcceptPolygamy,
                  onSubmit: (result) {
                    acceptsPolygamy = result;
                    _listenToData(asFemaleCompleteProfileBody.copyWith(doYouAcceptPolygamy: acceptsPolygamy.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),
            )..insertAll(21, [
              RadioWidget<Answer>(
                  title: LocaleKeys.areYouWaringHijab,
                  onSubmit: (result) {
                    wearingHijab.value = result;
                    _listenToData(asFemaleCompleteProfileBody.copyWith(wearingHijab: wearingHijab.value.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),

              ValueListenableBuilder(
                    valueListenable: wearingHijab,
                    builder: (context, value, child) => value.isYes? DropDownTextField<TitleValueShape>(
                      hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                      values: EnumsData.religiousCommitment.data,
                      title: LocaleKeys.degreeOfCommitment,
                      itemBuilder: (v) => AppText(v.title.tr()),
                      onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(degreeOfCommitment: value?.value)),
                    ) : const SizedBox.shrink(),
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
        return SharedFormFields<FemaleParentCompleteProfileBody>(
          restorationId: 'female_fields',
          onFinished: (data) => _listenToData(data.copyWith()),
          onInitData: (List<Widget> children) => children
            ..insertAll(15, [
              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _liveAfterMarryCont,
                inputType: TextInputType.phone,
                onChanged: (value) => _listenToData(asFemaleParentCompleteProfileBody.copyWith(liveAfterMarry: _liveAfterMarryCont.text)),
                // validator: Validators.validateEmpty,
              ),
            ])
            ..insertAll(17, [
              RadioWidget<Answer>(
                  title: LocaleKeys.doYouAcceptPolygamy,
                  onSubmit: (result) {
                    acceptsPolygamy = result;
                    _listenToData(asFemaleParentCompleteProfileBody.copyWith(doYouAcceptPolygamy: acceptsPolygamy.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),
            ])
            ..insertAll(21, [
              RadioWidget<Answer>(
                  title: LocaleKeys.areYouWaringHijab,
                  onSubmit: (result) {
                    wearingHijab.value = result;
                    _listenToData(asFemaleParentCompleteProfileBody.copyWith(wearingHijab: wearingHijab.value.toBool));
                  },
                  values: Answer.values,
                titleBuilder: (i) => AppText(Answer.values[i].translate),
              ),

              ValueListenableBuilder(
                valueListenable: wearingHijab,
                builder: (context, value, child) => value.isYes? DropDownTextField<TitleValueShape>(
                  hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
                  values: EnumsData.religiousCommitment.data,
                  title: LocaleKeys.degreeOfCommitment,
                  itemBuilder: (v) => AppText(v.title.tr()),
                  onChanged: (value) => _listenToData(asFemaleCompleteProfileBody.copyWith(degreeOfCommitment: value?.value)),
                ) : const SizedBox.shrink(),
              ),
            ])
            ..insert(
              0,
              SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameCont,
                onChanged: (val) => _listenToData(
                    asFemaleParentCompleteProfileBody.copyWith(name: _nameCont.text)
                ),
                // validator: Validators.validateEmpty,
              ),
            ),
        );
    }
  }
}