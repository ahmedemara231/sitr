import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import 'delete_account_warning_icon.dart';

class DeleteAccountReasonHeader extends StatelessWidget {
  final Animation<double> animation;

  const DeleteAccountReasonHeader({
    required this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DeleteAccountWarningIcon(animation: animation),
        18.szH,
        AppText(
          LocaleKeys.whyAreYouDeletingYourAccount,
          textAlign: TextAlign.center,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.deleteAccountReasonText,
          height: 1.45,
        ).paddingSymmetric(horizontal: 20.w),
        8.szH,
        AppText(
          LocaleKeys.chooseDeleteAccountReasonHint,
          textAlign: TextAlign.center,
          fontSize: 13.sp,
          color: AppColors.deleteAccountReasonMuted,
          height: 1.65,
        ).paddingSymmetric(horizontal: 24.w),
        20.szH,
      ],
    );
  }
}
