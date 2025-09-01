import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../config/language/locale_keys.g.dart';

class OtpStaticTexts extends StatelessWidget {
  const OtpStaticTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(LocaleKeys.otpCode, fontWeight: FontWeight.w500, fontSize: 16.sp),
        AppText(
            LocaleKeys.pleaseEnterTheActivationCodeSentToYourMobileNumber,
            textAlign: TextAlign.center,
            fontSize: 12.sp
        ),
      ],
    );
  }
}
