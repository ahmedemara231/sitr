import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../features/packages/presentation/screens/subscription_screen.dart';
import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/data/models/promotion_subscription_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_data_cubit.dart';
import '../../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import '../../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../navigation/navigator.dart';
import '../../../shared/user_cubit/user_cubit.dart';
import '../../app_text.dart';
import '../success_sheet.dart';
import '../../default_bottom_sheet.dart';
import 'promotion_plans_content.dart';
import 'promotion_plans_states.dart';
import 'promotion_sheet_chrome.dart';

class PromotionPlansSheetBody extends StatefulWidget {
  final FutureOr<void> Function()? onSuccess;
  final bool _isSheet;

  const PromotionPlansSheetBody({
    super.key,
    this.onSuccess,
  }) : _isSheet = true;

  const PromotionPlansSheetBody.screen({
    super.key,
    this.onSuccess,
  }) : _isSheet = false;

  @override
  State<PromotionPlansSheetBody> createState() =>
      _PromotionPlansSheetBodyState();
}

class _PromotionPlansSheetBodyState extends State<PromotionPlansSheetBody> {
  int? _selectedPlanId;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    context.read<PromotionDataCubit>().getPromotionData();
  }

  Future<void> _subscribe(
    BuildContext sheetContext,
    PromotionPlanModel plan,
  ) async {
    if (_isSubscribed) return;

    final String link = await sheetContext
        .read<PromotionSubscriptionCubit>()
        .subscribe(planId: plan.id);
    if (link.isEmpty) return;
    if (!sheetContext.mounted) return;

    final Object? result = await Go.to(
      SubscriptionScreen(
        initialUrl: link,
        title: LocaleKeys.pay,
      ),
    );
    if (!mounted) return;

    if (result == 'success') {
      await UserCubit.instance.refreshProfile();
      await widget.onSuccess?.call();
      if (!mounted) return;

      setState(() => _isSubscribed = true);
      if (widget._isSheet) {
        Go.back();
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      await showDefaultBottomSheet(
        child: SuccessSheet(
          isInAuth: false,
          upperText: AppText(
            LocaleKeys.paymentSucceeded,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PromotionSheetDataModel promotionSheet =
        context.watch<PromotionDataCubit>().state.data.promotionSheet;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: widget._isSheet
            ? _buildSheet(context, promotionSheet)
            : _buildScreen(context, promotionSheet),
      ),
    );
  }

  Widget _buildSheet(
    BuildContext context,
    PromotionSheetDataModel promotionSheet,
  ) {
    final double maxSheetHeight = MediaQuery.sizeOf(context).height * 0.86;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PromotionSheetHandle(),
              PromotionSheetHeader(data: promotionSheet),
              Flexible(child: _buildPlans()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreen(
    BuildContext context,
    PromotionSheetDataModel promotionSheet,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.06),
            blurRadius: 24.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            PromotionSheetHeader(
              data: promotionSheet,
              showCloseButton: false,
            ),
            Expanded(child: _buildPlans()),
          ],
        ),
      ),
    );
  }

  Widget _buildPlans() {
    return BlocBuilder<PromotionDataCubit, AsyncState<PromotionDataModel>>(
      builder: (context, state) {
        final PromotionSheetDataModel promotionSheet =
            state.data.promotionSheet;
        final PromotionPlansModel data = promotionSheet.plansData;
        if ((state.isLoading || state.isInitial) && data.plans.isEmpty) {
          return const PromotionPlansLoading();
        }

        if (data.plans.isEmpty) {
          return PromotionPlansError(
            message: state.msg,
            onRetry: () =>
                context.read<PromotionDataCubit>().getPromotionData(),
          );
        }

        return BlocBuilder<PromotionSubscriptionCubit,
            AsyncState<PromotionSubscriptionModel>>(
          builder: (context, subscriptionState) => PromotionPlansContent(
            data: data,
            content: promotionSheet,
            selectedPlanId: _selectedPlanId,
            isSubscribing: subscriptionState.isLoading,
            isSubscribed: _isSubscribed,
            onPlanSelected: (plan) {
              setState(() => _selectedPlanId = plan.id);
            },
            onSubscribe: (plan) => _subscribe(context, plan),
          ),
        );
      },
    );
  }
}
