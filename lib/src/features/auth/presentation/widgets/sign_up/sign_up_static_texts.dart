import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/language/locale_keys.g.dart';

class SignUpStaticTexts extends StatelessWidget {
  const SignUpStaticTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(LocaleKeys.createAccount, fontWeight: FontWeight.w500, fontSize: 16.sp),
        AppText(
            LocaleKeys.pleaseEnterTheFollowingInformationToCreateANewAccount,
            textAlign: TextAlign.center,
            fontSize: 12.sp
        ),
      ],
    );
  }
}
