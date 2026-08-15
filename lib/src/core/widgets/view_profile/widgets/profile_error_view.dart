import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../navigation/navigator.dart';
import '../../app_text.dart';
import '../../buttons/default_button.dart';
import '../../scaffolds/app_scaffold.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: AppColors.whiteScaffoldBackground,
      body: Column(
        children: [
          AppText(
            LocaleKeys.chatReasonHasProblem,
            fontWeight: FontWeight.w500,
          ),
          Lottie.asset(
            Assets.assets.lottie.data.incompleteProfile.path,
          ),
          DefaultButton(
            title: LocaleKeys.back,
            onTap: Go.back,
            borderRadius: BorderRadius.circular(50.r),
          ),
        ],
      ),
    );
  }
}
