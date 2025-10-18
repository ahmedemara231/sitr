import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/individual/male_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../shared/text_field.dart';
import 'image_widget.dart';
import 'shared_form_fields.dart';

class MaleFields extends StatefulWidget {
  final UserType? secondaryType;
  final void Function(IndividualUserModel data) onFinishMaleData;

  const MaleFields({
    super.key,
    required this.secondaryType,
    required this.onFinishMaleData,
  });

  @override
  State<MaleFields> createState() => _MaleFieldsState();
}

class _MaleFieldsState extends State<MaleFields> {
  late IndividualUserModel sharedFormFieldModel;
  File? selectedImage;

  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;

  void _init() => sharedFormFieldModel = MaleModel.initial();

  UserModel get _currentUser => UserModel.currentUser ?? UserModel.initial();

  @override
  void initState() {
    _init();
    _nameCont = TextEditingController(text: UserModel.isParent? null : _currentUser.name);
    _phoneCont = TextEditingController(text: UserModel.isParent? null : _currentUser.phone);
    _identifyNumberCont = TextEditingController(text: UserModel.isParent? null : _currentUser.identityNumber);
    _ageCont = TextEditingController(text: UserModel.isParent? null : _currentUser.age.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    super.dispose();
  }

  void _listenToData(IndividualUserModel updatedModel) {
    sharedFormFieldModel = updatedModel;
    widget.onFinishMaleData.call(sharedFormFieldModel);
  }

  MaleModel get asMaleModel => sharedFormFieldModel as MaleModel;
  @override
  Widget build(BuildContext context) {
    switch (widget.secondaryType) {
      case null:
        return SharedFormFields<MaleModel>(
          restorationId: UserType.male.name,
          onFinished: (data) =>
              _listenToData(asMaleModel.merge(data.copyWith())),
        );

      default:
        return SharedFormFields<MaleModel>(
          restorationId: UserType.male.name,
          onFinished: (data) =>
              _listenToData(asMaleModel.merge(data.copyWith())),
          onInitData: (List<Widget> children) => children
            ..insertAll(
              0,
              [
                SelectImageWidget(onSelectImage: (image) {
                  selectedImage = image;
                  _listenToData(
                      asMaleModel.copyWith(avatar: selectedImage?.path));
                }),
                SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameCont,
                onChanged: (val) =>
                    _listenToData(asMaleModel.copyWith(name: _nameCont.text)),
                // validator: Validators.validateEmpty,
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
                  // validator: Validators.validateEmpty,
                ),
            )
            ..insertAll(7, [
              SignUpTextField(
                upperTitle: LocaleKeys.identifyNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _identifyNumberCont,
                inputType: TextInputType.number,
                onChanged: (val) => _listenToData(asMaleModel.copyWith(
                    identityNumber: _identifyNumberCont.text)),
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.age,
                title: LocaleKeys.pleaseEnterYourAge,
                inputType: TextInputType.number,
                controller: _ageCont,
                onChanged: (val) => _listenToData(
                    asMaleModel.copyWith(age: int.tryParse(_ageCont.text))),
                // validator: Validators.validateEmpty,
              ),
            ])
        );
    }
  }
}
