import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/auth/presentation/screens/complete_profile.dart';
import '../../navigation/navigator.dart';
import '../buttons/custom_app_buttons/default_button.dart';

class SuccessSheet extends StatelessWidget {
  const SuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        Lottie.asset(Assets.successDone),
        AppText(LocaleKeys.paymentSucceeded, fontSize: 16.sp, fontWeight: FontWeight.bold),
        AppText(LocaleKeys.youCanNowCompleteYourProfile),
        AppDefaultButton.withBackGroundColor(
            title: LocaleKeys.completeProfile,
            onTap: () => Go.to(const CompleteProfileScreen())
        )
      ],
    );
  }
}
