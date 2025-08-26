import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_animated_button.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/buttons/loading_button.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../widgets/do_not_have_acc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return AppScaffold.withUpperWidget(
      isScrollable: true,
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
          AppText(LocaleKeys.login, fontWeight: FontWeight.w500, fontSize: 16.sp),
          AppText(LocaleKeys.pleaseEnterYourMobileNumberToRegisterOrSkipToRegisterAndViewSomeApplicationData),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        ),
        child: Column(
          spacing: 10.h,
          children: [
            DefaultTextField.withTitle(
              upperTitle: LocaleKeys.login,
              title: LocaleKeys.pleaseEnterPhoneNumber,
              fillColor: Colors.grey[50],
            ),
            LoadingButton(
              title: LocaleKeys.login,
              borderRadius: 40.r,
              height: 50.h,
              onTap: () async {},
              btnKey: GlobalKey<CustomButtonState>(),
            ),
            const DoNotHaveAccountWidget(),
            DefaultButton(
              color: AppColors.thirdColor,
              title: LocaleKeys.signInAsVisitor,
              textColor: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              onTap: (){},
            )
          ],
        ).defaultScreenPadding(),
      ),
    );
  }
}
