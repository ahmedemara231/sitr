import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_data_cubit.dart';
import '../../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../helpers/status_builder.dart';
import 'promotion_plans_state_view.dart';
import 'promotion_plans_states.dart';

class PromotionPlansStatusBuilder extends StatelessWidget {
  final int? selectedPlanId;
  final bool isSubscribed;
  final void Function(PromotionPlanModel plan) onPlanSelected;
  final void Function(PromotionPlanModel plan) onSubscribe;

  const PromotionPlansStatusBuilder({
    required this.selectedPlanId,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionDataCubit, AsyncState<PromotionDataModel>>(
      builder: (BuildContext context, AsyncState<PromotionDataModel> state) {
        final PromotionPlansError error = PromotionPlansError(
          message: state.msg,
          onRetry: () => context.read<PromotionDataCubit>().getPromotionData(),
        );

        return StatusBuilder<PromotionDataModel>(
          data: state,
          onLoading: () => PromotionPlansStateView(
            content: state.data.promotionSheet,
            emptyState: const PromotionPlansLoading(),
            selectedPlanId: selectedPlanId,
            isSubscribed: isSubscribed,
            onPlanSelected: onPlanSelected,
            onSubscribe: onSubscribe,
          ),
          onFail: () => PromotionPlansStateView(
            content: state.data.promotionSheet,
            emptyState: error,
            selectedPlanId: selectedPlanId,
            isSubscribed: isSubscribed,
            onPlanSelected: onPlanSelected,
            onSubscribe: onSubscribe,
          ),
          onSuccess: (
            PromotionDataModel data,
            BuildContext context,
          ) =>
              PromotionPlansStateView(
            content: data.promotionSheet,
            emptyState: state.isInitial ? const PromotionPlansLoading() : error,
            selectedPlanId: selectedPlanId,
            isSubscribed: isSubscribed,
            onPlanSelected: onPlanSelected,
            onSubscribe: onSubscribe,
          ),
        );
      },
    );
  }
}
