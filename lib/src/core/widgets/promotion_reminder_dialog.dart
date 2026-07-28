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

Future<void> showPromotionReminderDialog() async {
  await showDialog<void>(
    context: Go.context,
    barrierColor: AppColors.blackShadow.withValues(alpha: 0.55),
    builder: (_) => const PromotionReminderDialog(),
  );
}

class PromotionReminderDialog extends StatelessWidget {
  const PromotionReminderDialog({super.key});

  List<String> get _features => [
        LocaleKeys.promotionFeatureSearchPriority,
        LocaleKeys.promotionFeatureProfileVisitors,
        LocaleKeys.promotionFeatureGoldenVerification,
      ];

  void _openPromotionPlans() {
    Go.back();
    Go.to(
      const PackagesScreen.promotion(),
      transition: TransitionType.slide,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: AppColors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PromotionReminderHeader(),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  20.w,
                  18.h,
                  20.w,
                  16.h,
                ),
                child: Column(
                  children: [
                    ..._features.map(
                      (feature) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _PromotionReminderFeature(title: feature),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _PromotionReminderPrimaryButton(
                      onTap: _openPromotionPlans,
                    ),
                    SizedBox(height: 6.h),
                    const _PromotionReminderLaterButton(onTap: Go.back),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromotionReminderHeader extends StatelessWidget {
  const _PromotionReminderHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 24.h, 24.w, 20.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            top: -54.h,
            end: -46.w,
            child: const _PromotionReminderDecoration(dimension: 126),
          ),
          PositionedDirectional(
            bottom: -70.h,
            start: -36.w,
            child: const _PromotionReminderDecoration(dimension: 112),
          ),
          Column(
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.16),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.24),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  alignment: Alignment.center,
                  child: IconWidget(
                    icon: Assets.svgPackagesScreenImage,
                    width: 28.w,
                    height: 31.h,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              AppText(
                LocaleKeys.promotionReminderTitle,
                color: AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              AppText(
                LocaleKeys.promotionReminderSubtitle,
                color: AppColors.promotionBadgeSubtitle,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromotionReminderDecoration extends StatelessWidget {
  final double dimension;

  const _PromotionReminderDecoration({required this.dimension});

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

class _PromotionReminderFeature extends StatelessWidget {
  final String title;

  const _PromotionReminderFeature({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: IconWidget(
              icon: Icons.check_rounded,
              color: AppColors.primary,
              width: 16.r,
              height: 16.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AppText(
              title,
              color: AppColors.darkGray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotionReminderPrimaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PromotionReminderPrimaryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(50.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: SizedBox(
          width: double.infinity,
          height: 54.h,
          child: Center(
            child: AppText(
              LocaleKeys.promotionReminderAction,
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _PromotionReminderLaterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PromotionReminderLaterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(50.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: SizedBox(
          width: double.infinity,
          height: 42.h,
          child: Center(
            child: AppText(
              LocaleKeys.promotionReminderLater,
              color: AppColors.darkGay,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
