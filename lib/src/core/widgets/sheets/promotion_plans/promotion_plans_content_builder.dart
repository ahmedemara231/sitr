import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/data/models/promotion_subscription_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_data_cubit.dart';
import '../../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import '../../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../extensions/widget_extension.dart';
import 'promotion_plans_content.dart';

class PromotionPlansContentBuilder extends StatelessWidget {
  final PromotionSheetDataModel content;
  final int? selectedPlanId;
  final bool isSubscribed;
  final void Function(PromotionPlanModel plan) onPlanSelected;
  final void Function(PromotionPlanModel plan) onSubscribe;

  const PromotionPlansContentBuilder({
    required this.content,
    required this.selectedPlanId,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PromotionPlansModel plans = content.plansData;

    return BlocBuilder<PromotionSubscriptionCubit,
        AsyncState<PromotionSubscriptionModel>>(
      builder:
          (BuildContext context, AsyncState<PromotionSubscriptionModel> state) {
        return PromotionPlansContent(
          data: plans,
          content: content,
          selectedPlanId: selectedPlanId,
          isSubscribing: state.isLoading,
          isSubscribed: isSubscribed,
          onPlanSelected: onPlanSelected,
          onSubscribe: onSubscribe,
        ).withPullRefresher(
          onRefresh: () =>
              context.read<PromotionDataCubit>().getPromotionData(),
        );
      },
    );
  }
}
