import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../config/language/locale_keys.g.dart';

class LoginStaticTexts extends StatelessWidget {
  const LoginStaticTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(LocaleKeys.login, fontWeight: FontWeight.w500, fontSize: 22.sp),
        AppText(
            LocaleKeys.pleaseEnterYourMobileNumberToRegisterOrSkipToRegisterAndViewSomeApplicationData,
            textAlign: TextAlign.center,
            fontSize: 16.sp
        ),
      ],
    );
  }
}
