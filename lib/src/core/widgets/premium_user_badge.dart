import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/sized_box_helper.dart';
import 'app_text.dart';
import 'icon_widget.dart';

class PremiumUserName extends StatelessWidget {
  final String name;
  final bool isPremium;
  final double? fontSize;

  const PremiumUserName({
    required this.name,
    required this.isPremium,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: AppText(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize ?? 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if(isPremium)
          const PremiumUserBadge(),
      ],
    );
  }
}

class PremiumUserBadge extends StatelessWidget {
  const PremiumUserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LocaleKeys.premiumUser,
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 4.w,
          top: 3.h,
          end: 8.w,
          bottom: 3.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackShadow.withValues(alpha: 0.02),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18.r,
              height: 18.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconWidget(
                icon: Icons.workspace_premium_rounded,
                width: 11.r,
                height: 11.r,
                color: AppColors.white,
              ),
            ),
            5.szW,
            AppText(
              LocaleKeys.premiumUser,
              color: AppColors.primary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
