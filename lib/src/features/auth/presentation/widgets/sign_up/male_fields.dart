import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../models/complete_profile/male_body.dart';
import '../../../models/shared_form_fields_model.dart';
import '../shared/text_field.dart';
import 'image_widget.dart';
import 'shared_form_fields.dart';

class MaleFields extends StatefulWidget {
  final UserType? secondaryType;
  final void Function(SharedFormFieldModel data) onFinishMaleData;

  const MaleFields({super.key,
    required this.secondaryType,
    required this.onFinishMaleData,
  });

  @override
  State<MaleFields> createState() => _MaleFieldsState();
}

class _MaleFieldsState extends State<MaleFields> {
  late SharedFormFieldModel sharedFormFieldModel;
  File? selectedImage;

  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;

  void _init(){
    switch(widget.secondaryType){
      case null:
        sharedFormFieldModel = MaleCompleteProfileBody.initial();

      default:
        sharedFormFieldModel = MaleParentCompleteProfileBody.initial();
    }
  }

  @override
  void initState() {
    _init();
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _ageCont = TextEditingController();
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

  final _formKey = GlobalKey<FormState>();

  void _listenToData(SharedFormFieldModel updatedModel) {
    sharedFormFieldModel = updatedModel;
    widget.onFinishMaleData.call(sharedFormFieldModel);
  }


  // MaleCompleteProfileBody get asMaleCompleteProfileBody{
  //   return sharedFormFieldModel as MaleCompleteProfileBody;
  // }

  MaleParentCompleteProfileBody get asMaleParentCompleteProfileBody{
    return sharedFormFieldModel as MaleParentCompleteProfileBody;
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.secondaryType){
      case null:
        return SharedFormFields<MaleCompleteProfileBody>(
          // sharedFormFieldModel: sharedFormFieldModel,
          restorationId: UserType.male.name,
          onFinished: (data) => _listenToData(data.copyWith()),
        );

      default:
        return SharedFormFields<MaleParentCompleteProfileBody>(
          // sharedFormFieldModel: sharedFormFieldModel,
          restorationId: UserType.male.name,
          onFinished: (data) => _listenToData(data.copyWith()),
          onInitData: (List<Widget> children) => children..insert(
            0,
            SignUpTextField(
              upperTitle: LocaleKeys.name,
              title: LocaleKeys.pleaseEnterName,
              controller: _nameCont,
              onChanged: (val) => _listenToData(asMaleParentCompleteProfileBody.copyWith(name: val)),
              // validator: Validators.validateEmpty,
            ),
          )..insertAll(
            2,
            [
              SignUpImageWidget(onSelectImage: (image) {
                selectedImage = image;
                _listenToData(asMaleParentCompleteProfileBody.copyWith(image: selectedImage));
              }),
              SignUpTextField(
                upperTitle: LocaleKeys.phoneNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _phoneCont,
                inputType: TextInputType.phone,
                onChanged: (val) => _listenToData(asMaleParentCompleteProfileBody.copyWith(name: val)),
                // validator: Validators.validateEmpty,
              ),
            ],
          )..insertAll(
              7,
              [
                SignUpTextField(
                  upperTitle: LocaleKeys.identifyNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _identifyNumberCont,
                  onChanged: (val) => _listenToData(asMaleParentCompleteProfileBody.copyWith(identifyNumber: val)),
                  // validator: Validators.validateEmpty,
                ),
                SignUpTextField(
                  upperTitle: LocaleKeys.age,
                  title: LocaleKeys.pleaseEnterYourAge,
                  controller: _ageCont,
                  onChanged: (val) => _listenToData(asMaleParentCompleteProfileBody.copyWith(age: val)),
                  // validator: Validators.validateEmpty,
                ),
              ]
          ),
        );
    }
  }
}