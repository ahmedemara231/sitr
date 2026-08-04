import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../app_text.dart';
import '../../icon_widget.dart';

class PromotionPlansList extends StatelessWidget {
  final List<PromotionPlanModel> plans;
  final int selectedPlanId;
  final ValueChanged<PromotionPlanModel> onPlanSelected;

  const PromotionPlansList({
    required this.plans,
    required this.selectedPlanId,
    required this.onPlanSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: plans
          .map(
            (PromotionPlanModel plan) => Padding(
              padding: EdgeInsets.only(
                top: plan.badge == null ? 0 : 6.h,
                bottom: 12.h,
              ),
              child: PromotionPlanCard(
                plan: plan,
                isActive: selectedPlanId == plan.id,
                onTap: () => onPlanSelected(plan),
              ),
            ),
          )
          .toList(),
    );
  }
}

class PromotionPlanCard extends StatelessWidget {
  final PromotionPlanModel plan;
  final bool isActive;
  final VoidCallback onTap;

  const PromotionPlanCard({
    required this.plan,
    required this.isActive,
    required this.onTap,
    super.key,
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
                color: isActive ? null : AppColors.whiteScaffoldBackground,
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
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          plan.duration,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color:
                              isActive ? AppColors.primary : AppColors.darkGray,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 3.h),
                        AppText(
                          plan.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.mediumGray,
                          fontSize: 11.sp,
                          height: 1.35,
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
          PositionedDirectional(
            top: -10.h,
            end: 14.w,
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
    required this.plan,
    required this.isActive,
    super.key,
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
            AppText(
              plan.priceText,
              color: color,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
            SizedBox(width: 3.w),
            AppText(
              plan.currency,
              color: isActive ? AppColors.primary : AppColors.mediumGray,
              fontSize: 12.sp,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        AppText(
          '/ ${plan.period}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.hintText,
          fontSize: 10.sp,
        ),
      ],
    );
  }
}

class PromotionPlanSelector extends StatelessWidget {
  final bool isActive;

  const PromotionPlanSelector({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return SizedBox.square(
        dimension: 18.r,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
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
      child: IconWidget(
        icon: Icons.check_rounded,
        color: AppColors.white,
        width: 13.sp,
        height: 13.sp,
      ),
    );
  }
}

class PromotionPlanBadge extends StatelessWidget {
  final String text;
  final bool isHighlight;

  const PromotionPlanBadge({
    required this.text,
    required this.isHighlight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isHighlight ? null : AppColors.darkGoldenRod,
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
      child: AppText(
        text,
        color: AppColors.white,
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
