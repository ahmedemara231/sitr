import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';

class PromotionPlansContent extends StatelessWidget {
  final PromotionPlansModel data;
  final int? selectedPlanId;
  final bool isSubscribing;
  final bool isSubscribed;
  final ValueChanged<PromotionPlanModel> onPlanSelected;
  final ValueChanged<PromotionPlanModel> onSubscribe;

  const PromotionPlansContent({
    super.key,
    required this.data,
    required this.selectedPlanId,
    required this.isSubscribing,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final int currentPlanId = selectedPlanId ?? data.defaultPlan.id;
    final PromotionPlanModel selectedPlan = data.plans.firstWhere(
      (plan) => plan.id == currentPlanId,
      orElse: () => data.defaultPlan,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: data.plans
                .map(
                  (plan) => Padding(
                    padding: EdgeInsets.only(
                      top: plan.badge == null ? 0 : 6.h,
                      bottom: 12.h,
                    ),
                    child: PromotionPlanCard(
                      plan: plan,
                      isActive: currentPlanId == plan.id,
                      onTap: () => onPlanSelected(plan),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 2.h),
          PromotionFeaturesList(features: data.features),
          SizedBox(height: 18.h),
          PromotionSubscribeButton(
            title:
                '${LocaleKeys.promotionSheetSubscribePrefix} ${selectedPlan.duration} - ${selectedPlan.priceText} ${selectedPlan.currency}',
            isLoading: isSubscribing,
            isDone: isSubscribed,
            onTap: () => onSubscribe(selectedPlan),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.promotionSheetCancelAnytime,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFBBBBBB),
              fontFamily: ConstantManager.fontFamily,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PromotionPlanCard extends StatelessWidget {
  final PromotionPlanModel plan;
  final bool isActive;
  final VoidCallback onTap;

  const PromotionPlanCard({
    super.key,
    required this.plan,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Ink(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isActive ? null : const Color(0xFFFAFAF8),
                gradient: isActive
                    ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.promotionBadgeGradientStart.withValues(
                            alpha: 0.08,
                          ),
                          AppColors.promotionBadgeGradientMiddle.withValues(
                            alpha: 0.05,
                          ),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  width: 2.r,
                  color: isActive ? AppColors.primary : const Color(0xFFEDE8E0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.duration,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.darkGray,
                            fontFamily: ConstantManager.fontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          plan.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontFamily: ConstantManager.fontFamily,
                            fontSize: 11.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  PromotionPlanPrice(plan: plan, isActive: isActive),
                  SizedBox(width: 10.w),
                  PromotionPlanSelector(isActive: isActive),
                ],
              ),
            ),
          ),
        ),
        if (plan.badge != null)
          Positioned(
            top: -10.h,
            left: 14.w,
            child: PromotionPlanBadge(
              text: plan.badge!,
              isHighlight: plan.isHighlighted,
            ),
          ),
      ],
    );
  }
}

class PromotionPlanPrice extends StatelessWidget {
  final PromotionPlanModel plan;
  final bool isActive;

  const PromotionPlanPrice({
    super.key,
    required this.plan,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.primary : AppColors.darkGray;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              plan.priceText,
              style: TextStyle(
                color: color,
                fontFamily: ConstantManager.fontFamily,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              plan.currency,
              style: TextStyle(
                color: isActive ? AppColors.primary : const Color(0xFF888888),
                fontFamily: ConstantManager.fontFamily,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          '/ ${plan.period}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFFAAAAAA),
            fontFamily: ConstantManager.fontFamily,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class PromotionPlanSelector extends StatelessWidget {
  final bool isActive;

  const PromotionPlanSelector({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return SizedBox.square(
        dimension: 18.r,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE0D8D0)),
          ),
        ),
      );
    }

    return Container(
      width: 18.r,
      height: 18.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.promotionBadgeGradientStart,
            AppColors.promotionBadgeGradientMiddle,
          ],
        ),
      ),
      child: Icon(
        Icons.check_rounded,
        color: AppColors.white,
        size: 13.sp,
      ),
    );
  }
}

class PromotionPlanBadge extends StatelessWidget {
  final String text;
  final bool isHighlight;

  const PromotionPlanBadge({
    super.key,
    required this.text,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isHighlight ? null : const Color(0xFF5C3D0E),
        gradient: isHighlight
            ? const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppColors.promotionBadgeGradientStart,
                  AppColors.promotionBadgeGradientMiddle,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.promotionBadgeShadow.withValues(alpha: 0.30),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.white,
          fontFamily: ConstantManager.fontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PromotionFeaturesList extends StatelessWidget {
  final List<PromotionFeatureModel> features;

  const PromotionFeaturesList({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${LocaleKeys.promotionSheetFeatureIntro}:',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: const Color(0xFF888888),
            fontFamily: ConstantManager.fontFamily,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        ...features.map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 7.h),
            child: Row(
              children: [
                const PromotionCheckIcon(),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    feature.title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontFamily: ConstantManager.fontFamily,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PromotionCheckIcon extends StatelessWidget {
  const PromotionCheckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14.r,
      height: 14.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
      child: Icon(
        Icons.check_rounded,
        color: AppColors.primary,
        size: 11.sp,
      ),
    );
  }
}

class PromotionSubscribeButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final bool isDone;
  final VoidCallback onTap;

  const PromotionSubscribeButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonText =
        isDone ? LocaleKeys.promotionSheetSubscribedSuccess : title;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: isLoading || isDone ? null : onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Ink(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFF2E7D32) : null,
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
                        child: Text(
                          buttonText,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: ConstantManager.fontFamily,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
