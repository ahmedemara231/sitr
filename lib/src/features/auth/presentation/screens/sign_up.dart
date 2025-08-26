import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/auth_scaffold.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
        upperWidget: SizedBox(
          height: context.height * .2,
          child: Column(
            spacing: 12.h,
            children: [
              const AppLogoWidget(),
              AppText(LocaleKeys.otpCode, fontWeight: FontWeight.w500, fontSize: 22.sp),
              AppText(
                  LocaleKeys.pleaseEnterTheActivationCodeSentToYourMobileNumber,
                  textAlign: TextAlign.center,
                  fontSize: 16.sp),
            ],
          ),
        ),
        body: const Column(
          children: [

          ],
        )
    );
  }
}
