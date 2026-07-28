import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/packages/presentation/packages_screen.dart';
import '../../../generated/assets.dart';
import '../navigation/Constants/imports_constants.dart';
import '../navigation/navigator.dart';
import 'app_text.dart';
import 'icon_widget.dart';

class PromotionBadge extends StatelessWidget {
  static const double height = 86;

  final FutureOr<void> Function()? onSuccess;

  const PromotionBadge({
    super.key,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => Go.to(
          PackagesScreen.promotion(onSuccess: onSuccess),
          transition: TransitionType.slide,
        ),
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          height: height.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.06),
                blurRadius: 24.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              children: [
                PositionedDirectional(
                  top: -34.h,
                  end: -18.w,
                  child: const _PromotionDecorationCircle(dimension: 108),
                ),
                PositionedDirectional(
                  bottom: -42.h,
                  start: 92.w,
                  child: const _PromotionDecorationCircle(dimension: 82),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    14.w,
                    12.h,
                    12.w,
                    12.h,
                  ),
                  child: Row(
                    children: [
                      const _PromotionIcon(),
                      SizedBox(width: 10.w),
                      const Expanded(child: _PromotionTextBlock()),
                      SizedBox(width: 8.w),
                      const _PromotionActionPill(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PromotionDecorationCircle extends StatelessWidget {
  final double dimension;

  const _PromotionDecorationCircle({required this.dimension});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension.r,
      height: dimension.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.07),
      ),
    );
  }
}

class _PromotionIcon extends StatelessWidget {
  const _PromotionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.16),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        alignment: Alignment.center,
        child: IconWidget(
          icon: Assets.svgPackagesScreenImage,
          width: 23.w,
          height: 25.h,
        ),
      ),
    );
  }
}

class _PromotionTextBlock extends StatelessWidget {
  const _PromotionTextBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          LocaleKeys.promotionBadgeTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        SizedBox(height: 4.h),
        AppText(
          LocaleKeys.promotionBadgeSubtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          height: 1.25,
        ),
      ],
    );
  }
}

class _PromotionActionPill extends StatelessWidget {
  const _PromotionActionPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(10.w, 7.h, 8.w, 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            LocaleKeys.promotionBadgeAction,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.primary,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          SizedBox(width: 3.w),
          IconWidget(
            icon: Icons.arrow_forward_ios_rounded,
            color: AppColors.primary,
            width: 11.sp,
            height: 11.sp,
          ),
        ],
      ),
    );
  }
}
