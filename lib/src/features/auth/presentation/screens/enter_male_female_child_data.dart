import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/helpers/cache_service.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../otp/models/otp_body.dart';
import '../../../otp/presentation/cubits/otp_cubit.dart';
import '../../../otp/presentation/otp.dart';
import '../../models/sign_up_body.dart';
import '../cubits/sign_up_cubit.dart';
import '../widgets/shared/choose_gender.dart';
import '../widgets/shared/text_field.dart';
import '../widgets/sign_up/already_have_acc.dart';
import '../widgets/sign_up/conditions_terms_acceptance.dart';
import '../widgets/sign_up/drop_down_text_field.dart';
import '../widgets/sign_up/image_widget.dart';
import '../widgets/sign_up/shared_form_fields.dart';
import '../widgets/sign_up/sign_up_upper_widget.dart';

enum ComesFrom{signUpAsPartner, signUpAsParent}
class EnterMaleOrFemaleOrChildDataScreen extends StatefulWidget {
  final ComesFrom from;
  final UserType? type;
  const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
    required this.type,
}) : from = ComesFrom.signUpAsPartner;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  }) : from = ComesFrom.signUpAsParent, type = null;

  @override
  State<EnterMaleOrFemaleOrChildDataScreen> createState() => _EnterMaleOrFemaleOrChildDataScreenState();
}

class _EnterMaleOrFemaleOrChildDataScreenState extends State<EnterMaleOrFemaleOrChildDataScreen> {
  UserType type = UserType.male;
  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    type = widget.type?? UserType.male;
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _ageCont = TextEditingController();
    _liveAfterMarryCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: Column(
          spacing: 10.h,
          children: [
            if(widget.type.isNull)
              ChooseGenderWidget(
                onSelectGender: (selectedGender) => setState(() => type = selectedGender),
                genders: const [
                  UserType.male,
                  UserType.female,
                ],
              ),

            if(type.isFemale)
              SharedFormFields(
                onFinished: (data){},
                onInitData: (List<Widget> children) => children..insertAll(18, [
                  SignUpTextField(
                    upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                    title: LocaleKeys.pleaseEnterTheNumber,
                    controller: _liveAfterMarryCont,
                    // validator: Validators.validateEmpty,
                  ),
                ])..insertAll(23, [
                  DropDownTextField(title: LocaleKeys.areYouWaringHijab),
                  DropDownTextField(title: LocaleKeys.degreeOfCommitment),
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
                ]),
              )
            else
              SharedFormFields(
                onFinished: (data){},
                onInitData: (List<Widget> children) => children..insertAll(2, [
                  SignUpImageWidget(onSelectImage: (img){}),
                  SignUpTextField(
                    upperTitle: LocaleKeys.phoneNumber,
                    title: LocaleKeys.pleaseEnterTheNumber,
                    controller: _phoneCont,
                    // validator: Validators.validateEmpty,
                  ),
                ])
                  ..insertAll(7, [
                    SignUpTextField(
                      upperTitle: LocaleKeys.identifyNumber,
                      title: LocaleKeys.pleaseEnterTheNumber,
                      controller: _identifyNumberCont,
                      // validator: Validators.validateEmpty,
                    ),
                    SignUpTextField(
                      upperTitle: LocaleKeys.age,
                      title: LocaleKeys.pleaseEnterYourAge,
                      controller: _ageCont,
                      // validator: Validators.validateEmpty,
                    ),
                  ]),
              ),

            const ConditionsTermsAcceptance(),
            AppLoadingButton(
              asyncCall: (ctx) async{
                final user =  (UserModel.fromJson(
                    jsonDecode(CacheStorage.read('user'))))
                    .gender!
                    .title!
                    .toUserType();

                log(user.toString());
                // if(_formKey.currentState!.validate()){
                //
                // }
              },
              title: LocaleKeys.confirm,
            ),
            if(widget.from == ComesFrom.signUpAsPartner)
              const AlreadyHaveAccWidget()
          ],
        )
    );
  }
}