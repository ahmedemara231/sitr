import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/widgets/app_text.dart';

class LoginStaticTexts extends StatelessWidget {
  const LoginStaticTexts({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Column(
      children: [
        AppText(LocaleKeys.login, fontWeight: FontWeight.w500, fontSize: 16.sp),
        AppText(
            LocaleKeys.pleaseEnterYourMobileNumberToRegisterOrSkipToRegisterAndViewSomeApplicationData,
            textAlign: TextAlign.center,
            fontSize: 12.sp
        ),
      ],
    );
  }
}
