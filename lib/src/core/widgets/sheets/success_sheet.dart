import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/auth/imports.dart' show EnterMaleOrFemaleOrChildDataScreen;
import '../../helpers/user_type_enum.dart';
import '../../navigation/navigator.dart';
import '../app_bottom_sheet.dart';

class SuccessSheet extends StatelessWidget {
  const SuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppBottomSheet.small(
            asyncCall: (context) => Go.to(
                UserTypeHelper.currentType!.isParent?
                const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent() :
                EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner(type: UserTypeHelper.currentType)
            ),
            btnTitle: LocaleKeys.completeProfile,
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
