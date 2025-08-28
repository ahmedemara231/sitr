import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../packages/presentation/packages_screen.dart';
import '../widgets/choose_gender.dart';
import '../widgets/sign_up_static_texts.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _ageCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _codeCont;

  @override
  void initState() {
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _ageCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _codeCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _ageCont.dispose();
    _identifyNumberCont.dispose();
    _codeCont.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
        upperWidget: SizedBox(
          height: context.height * .2,
          child: Column(
            spacing: 12.h,
            children: [
              Row(
                spacing: context.width / 8,
                children: [
                  LangIcon(onSelectLang: (lang){}),
                  const AppLogoWidget(),
                ],
              ),
              const SignUpStaticTexts()
            ],
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ChooseGenderWidget(onSelectGender: (selectedGender) {}),
              10.szH,
              SignUpTextField(
                upperTitle: LocaleKeys.profilePicture,
                title: LocaleKeys.pleaseEnterYourProfilePicture,
                suffixIconPath: Assets.svgCamera,
                controller: TextEditingController(),
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterYourName,
                controller: _nameCont,
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.phoneNumber,
                title: LocaleKeys.pleaseEnterPhoneNumber,
                controller: _phoneCont,
                // validator: Validators.validatePhone,
                inputType: TextInputType.number,
              ),
              SignUpTextField(
                  upperTitle: LocaleKeys.age,
                  title: LocaleKeys.pleaseEnterYourAge,
                  controller: _ageCont,
                inputType: TextInputType.number,
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                  upperTitle: LocaleKeys.identifyNumber,
                  title: LocaleKeys.pleaseEnterYourIdentifyNumber,
                  controller: _identifyNumberCont,
                inputType: TextInputType.number,
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                  upperTitle: LocaleKeys.code,
                  title: LocaleKeys.pleaseEnterYourCode,
                  controller: _codeCont,
                inputType: TextInputType.number,
                // validator: Validators.validateEmpty,
              ),
              10.szH,
              AppDefaultButton.withBackGroundColor(
                  title: LocaleKeys.confirm,
                  onTap: (){
                    if(formKey.currentState!.validate()){
                      Go.to(const PackagesScreen.view());
                    }
                  }
              )
            ],
          ),
        )
    );
  }
}
