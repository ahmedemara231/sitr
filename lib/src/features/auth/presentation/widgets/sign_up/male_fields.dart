import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/individual/male_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../shared/text_field.dart';
import 'shared_form_fields.dart';

class MaleFields extends StatefulWidget {
  final bool withParent;
  final IndividualUserModel? initialValue;
  final void Function(IndividualUserModel data) onChangeMaleData;

  const MaleFields({
    super.key,
    this.initialValue,
    required this.withParent,
    required this.onChangeMaleData,
  });

  @override
  State<MaleFields> createState() => _MaleFieldsState();
}

class _MaleFieldsState extends State<MaleFields> {
  late IndividualUserModel maleFields;
  File? selectedImage;

  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  // late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;

  void _init() {
    maleFields = MaleModel.initial();
    _listenToData(maleFields.copyWith(
        gender: GenderValueShape(userGender: UserGender.male)
    ));
  }


  @override
  void initState() {
    _init();
    _nameCont = TextEditingController(text: widget.initialValue?.name);
    _phoneCont = TextEditingController(text: widget.initialValue?.phone);
    // _identifyNumberCont = TextEditingController(text: widget.initialValue?.identityNumber);
    _ageCont = TextEditingController(text: widget.initialValue?.age.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    // _identifyNumberCont.dispose();
    _ageCont.dispose();
    super.dispose();
  }

  void _listenToData(IndividualUserModel updatedModel) {
    maleFields = updatedModel;
    widget.onChangeMaleData.call(maleFields);
  }

  MaleModel get asMaleModel => maleFields as MaleModel;
  @override
  Widget build(BuildContext context) {
    switch (widget.withParent) {
      case false:
        return SharedFormFields<MaleModel>(
          initialValue: widget.initialValue,
          restorationId: UserGender.male.name,
          onChanged: (data) => _listenToData(asMaleModel.merge(data.copyWith())),
        );

      default:
        return SharedFormFields<MaleModel>(
          restorationId: UserGender.male.name,
          initialValue: widget.initialValue,
          onChanged: (data) => _listenToData(asMaleModel.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children
            ..insertAll(
              0,
              [
                SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameCont,
                onChanged: (val) =>
                    _listenToData(asMaleModel.copyWith(name: _nameCont.text)),
                validator: (v) => Validators.validateName(v, fieldTitle: LocaleKeys.name.tr()),
              ),
              ]
            )
            ..insert(
              2,
                SignUpTextField(
                  upperTitle: LocaleKeys.phoneNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _phoneCont,
                  inputType: TextInputType.phone,
                  onChanged: (val) => _listenToData(
                      asMaleModel.copyWith(phone: _phoneCont.text)),
                  validator: Validators.validatePhone,
                ),
            )
            ..insertAll(
                7,
                [
              // SignUpTextField(
              //   upperTitle: LocaleKeys.identifyNumber,
              //   title: LocaleKeys.pleaseEnterTheNumber,
              //   controller: _identifyNumberCont,
              //   inputType: TextInputType.number,
              //   onChanged: (val) => _listenToData(asMaleModel.copyWith(
              //       identityNumber: _identifyNumberCont.text)),
              //   validator: (v) => Validators.validateIdentityNumber(v, fieldTitle: LocaleKeys.identifyNumber.tr()),
              // ),
              SignUpTextField(
                upperTitle: LocaleKeys.age,
                title: LocaleKeys.pleaseEnterYourAge,
                inputType: TextInputType.number,
                controller: _ageCont,
                onChanged: (val) => _listenToData(
                    asMaleModel.copyWith(age: int.tryParse(_ageCont.text))),
                validator: (v) => Validators.validateAge(v, fieldTitle: LocaleKeys.age.tr(), isRequired: true),
              ),
            ]
            )
        );
    }
  }
}
