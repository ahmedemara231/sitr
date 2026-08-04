import 'package:flutter/material.dart';

import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import 'promotion_plans_content_builder.dart';

class PromotionPlansStateView extends StatelessWidget {
  final PromotionSheetDataModel content;
  final Widget emptyState;
  final int? selectedPlanId;
  final bool isSubscribed;
  final void Function(PromotionPlanModel plan) onPlanSelected;
  final void Function(PromotionPlanModel plan) onSubscribe;

  const PromotionPlansStateView({
    required this.content,
    required this.emptyState,
    required this.selectedPlanId,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (content.plansData.plans.isEmpty) return emptyState;

    return PromotionPlansContentBuilder(
      content: content,
      selectedPlanId: selectedPlanId,
      isSubscribed: isSubscribed,
      onPlanSelected: onPlanSelected,
      onSubscribe: onSubscribe,
    );
  }
}
