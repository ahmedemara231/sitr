import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../widgets/do_not_have_acc.dart';
import '../widgets/login_static_texts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _phoneCont;
  @override
  void initState() {
    _phoneCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return AuthScaffold(
      upperWidget: Column(
        spacing: 12.h,
        children: [
          Row(
            spacing: context.width / 8,
            children: [
              LangIcon(onSelectLang: (lang){}),
              const AppLogoWidget(),
            ],
          ),
          const LoginStaticTexts()
        ],
      ),
      body: SizedBox(
        height: context.height * .7,
        child: Column(
          spacing: 7.h,
          children: [
            Form(
              key: formKey,
              child: DefaultTextField.withTitle(
                upperTitle: LocaleKeys.phoneNumber,
                inputType: TextInputType.phone,
                title: LocaleKeys.pleaseEnterPhoneNumber,
                fillColor: Colors.grey[50],
                validator: Validators.validatePhone,
                controller: _phoneCont,
              ),
            ),
            AppLoadingButton(
              title: LocaleKeys.login,
              asyncCall: () async {},
            ),
            const DoNotHaveAccountWidget(),
            DefaultButton(
              borderRadius: ConstantManager.buttonBorderRadius,
              color: AppColors.thirdColor,
              title: LocaleKeys.signInAsVisitor,
              textColor: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              onTap: (){
                if(formKey.currentState!.validate()){

                }
              },
            )
          ],
        ),
      ),
    );
  }
}
