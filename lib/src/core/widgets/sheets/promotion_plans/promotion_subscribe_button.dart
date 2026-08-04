import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../app_text.dart';

class PromotionSubscribeButton extends StatelessWidget {
  final String title;
  final String successTitle;
  final bool isLoading;
  final bool isDone;
  final VoidCallback onTap;

  const PromotionSubscribeButton({
    required this.title,
    required this.successTitle,
    required this.isLoading,
    required this.isDone,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonText = isDone ? successTitle : title;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: isLoading || isDone ? null : onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Ink(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDone ? AppColors.main : null,
            gradient: isDone
                ? null
                : const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      AppColors.promotionBadgeGradientStart,
                      AppColors.promotionBadgeGradientMiddle,
                      AppColors.promotionBadgeGradientEnd,
                    ],
                  ),
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.promotionBadgeShadow.withValues(alpha: 0.38),
                blurRadius: 24.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isLoading
                  ? SizedBox.square(
                      key: const ValueKey<String>('loading'),
                      dimension: 21.r,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.4.r,
                      ),
                    )
                  : Padding(
                      key: ValueKey<String>(buttonText),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AppText(
                          buttonText,
                          maxLines: 1,
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
