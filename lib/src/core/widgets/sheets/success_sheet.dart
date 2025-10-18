import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/auth/imports.dart' show EnterMaleOrFemaleOrChildDataScreen;
import '../../helpers/user_type_enum.dart';
import '../../navigation/navigator.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart' show AppText;

class SuccessSheet extends StatelessWidget {
  final bool isInAuth;
  const SuccessSheet({super.key,
    required this.isInAuth
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppBottomSheet.small(
            asyncCall: (context) => !isInAuth?
            Go.back() :
            Go.to(
                UserTypeHelper.currentType!.isParent?
                const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent() :
                EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner()
            ),
            btnTitle: !isInAuth? LocaleKeys.back : LocaleKeys.completeProfile,
            upperWidget: Column(
              children: [
                Lottie.asset(Assets.successDone),
                AppText(LocaleKeys.paymentSucceeded, fontSize: 16.sp, fontWeight: FontWeight.bold),
                AppText(LocaleKeys.youCanNowCompleteYourProfile),
              ],
            )
        )
      ],
    );
  }
}
