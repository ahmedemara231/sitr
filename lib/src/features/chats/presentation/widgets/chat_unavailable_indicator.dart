import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/icon_widget.dart';

class ChatUnavailableIndicator extends StatelessWidget {
  final String message;
  final String icon;

  const ChatUnavailableIndicator({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackShadow.withValues(alpha: 0.06),
              offset: Offset(0.w, 3.h),
              blurRadius: 64.r,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: IconWidget(
                icon: icon,
                color: AppColors.error,
              ),
            ),
            12.szW,
            Expanded(
              child: AppText(
                message,
                color: AppColors.darkGray,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16.w, vertical: 12.h),
    );
  }
}
