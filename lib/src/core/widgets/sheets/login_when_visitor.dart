import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/auth/imports.dart';
import '../../navigation/navigator.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';

class LoginWhenVisitorSheet extends StatelessWidget {
  const LoginWhenVisitorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AppBottomSheet.large(
          asyncCall: (context) => Go.offAll(const LoginScreen()),
          btnTitle: LocaleKeys.login,
          cancelBackgroundColor: AppColors.pink,
          upperWidget: Column(
            spacing: 12.h,
            children: [
              Image.asset(Assets.imagesLogoutImage),
              AppText(LocaleKeys.loginFirst)
            ],
          )
      ),
    );
  }
}
