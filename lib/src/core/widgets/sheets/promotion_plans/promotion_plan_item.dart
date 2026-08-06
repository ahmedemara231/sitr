import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/data/models/promotion_sheet_model.dart';
import 'promotion_plan_card.dart';
import 'promotion_plans_content.dart';

class PromotionPlanItem extends StatelessWidget {
  final List<PromotionPlanModel> plans;
  final List<PromotionFeatureModel> features;
  final int index;
  final PromotionPlanModel plan;
  final PromotionSheetDataModel content;
  final int? selectedPlanId;
  final bool isSubscribing;
  final bool isSubscribed;
  final ValueChanged<PromotionPlanModel> onPlanSelected;
  final ValueChanged<PromotionPlanModel> onSubscribe;

  const PromotionPlanItem({
    required this.plans,
    required this.features,
    required this.index,
    required this.plan,
    required this.content,
    required this.selectedPlanId,
    required this.isSubscribing,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PromotionPlansModel plansData = PromotionPlansModel(
      plans: plans,
      features: features,
    );
    final int currentPlanId = selectedPlanId ?? plansData.defaultPlan.id;
    final PromotionPlanModel selectedPlan = plans.firstWhere(
      (PromotionPlanModel item) => item.id == currentPlanId,
      orElse: () => plansData.defaultPlan,
    );
    final bool isLastPlan = index == plans.length - 1;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        16.w,
        plan.badge == null ? 6.h : 16.h,
        16.w,
        isLastPlan ? 16.h : 6.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromotionPlanCard(
            plan: plan,
            isActive: currentPlanId == plan.id,
            onTap: () => onPlanSelected(plan),
          ),
          if (isLastPlan) ...[
            SizedBox(height: 12.h),
            PromotionPlansFooter(
              features: features,
              content: content,
              selectedPlan: selectedPlan,
              isSubscribing: isSubscribing,
              isSubscribed: isSubscribed,
              onSubscribe: onSubscribe,
            ),
          ],
        ],
      ),
    );
  }
}
