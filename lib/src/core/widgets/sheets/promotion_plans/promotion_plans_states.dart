import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../extensions/sized_box_helper.dart';
import '../../app_text.dart';
import '../../icon_widget.dart';

class PromotionPlansLoading extends StatelessWidget {
  const PromotionPlansLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 28.r,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.4.r,
            ),
          ),
          14.szH,
          AppText(
            '${LocaleKeys.promotionSheetLoading}...',
            color: AppColors.mediumGray,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class PromotionPlansError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const PromotionPlansError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconWidget(
                icon: Icons.error_outline_rounded,
                color: AppColors.primary,
                width: 30.sp,
                height: 30.sp,
              ),
              SizedBox(height: 10.h),
              AppText(
                message ?? LocaleKeys.checkInternet,
                textAlign: TextAlign.center,
                color: AppColors.mediumGray,
                fontSize: 13.sp,
                height: 1.5,
              ),
              SizedBox(height: 14.h),
              TextButton.icon(
                onPressed: onRetry,
                icon: IconWidget(
                  icon: Icons.refresh_rounded,
                  color: AppColors.primary,
                  width: 18.sp,
                  height: 18.sp,
                ),
                label: AppText(
                  LocaleKeys.tryAgain,
                  color: AppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
