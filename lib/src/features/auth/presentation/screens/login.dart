import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../widgets/do_not_have_acc.dart';
import '../widgets/login_static_texts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
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
            const LoginStaticTexts()
          ],
        ),
      ),
      body: SizedBox(
        height: context.height * .7,
        child: Column(
          spacing: 7.h,
          children: [
            DefaultTextField.withTitle(
              upperTitle: LocaleKeys.phoneNumber,
              inputType: TextInputType.phone,
              title: LocaleKeys.pleaseEnterPhoneNumber,
              fillColor: Colors.grey[50],
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
              onTap: (){},
            )
          ],
        ),
      ),
    );
  }
}
