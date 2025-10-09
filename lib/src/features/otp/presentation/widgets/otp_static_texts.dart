import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/app_text.dart';

class OtpStaticTexts extends StatelessWidget {
  final String phone;
  const OtpStaticTexts({super.key,
    required this.phone
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(LocaleKeys.otpCode, fontWeight: FontWeight.w500, fontSize: 16.sp),
        AppText(
            '${LocaleKeys.pleaseEnterTheActivationCodeSentToYourMobileNumber} $phone',
            textAlign: TextAlign.center,
            fontSize: 12.sp
        ),
      ],
    );
  }
}
