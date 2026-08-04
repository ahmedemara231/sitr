import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../features/packages/presentation/screens/subscription_screen.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_data_cubit.dart';
import '../../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import '../../../navigation/navigator.dart';
import '../../../shared/user_cubit/user_cubit.dart';
import '../../app_text.dart';
import '../../default_bottom_sheet.dart';
import '../success_sheet.dart';
import 'promotion_plans_status_builder.dart';

class PromotionPlansView extends StatefulWidget {
  final FutureOr<void> Function()? onSuccess;
  final FutureOr<void> Function()? onBeforeSuccessMessage;

  const PromotionPlansView({
    this.onSuccess,
    this.onBeforeSuccessMessage,
    super.key,
  });

  @override
  State<PromotionPlansView> createState() => _PromotionPlansViewState();
}

class _PromotionPlansViewState extends State<PromotionPlansView> {
  int? _selectedPlanId;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PromotionDataCubit>().getPromotionData();
    });
  }

  Future<void> _subscribe(PromotionPlanModel plan) async {
    if (_isSubscribed) return;

    final String link = await context
        .read<PromotionSubscriptionCubit>()
        .subscribe(planId: plan.id);
    if (link.isEmpty || !mounted) return;

    final Object? result = await Go.to(
      SubscriptionScreen(
        initialUrl: link,
        title: LocaleKeys.pay,
      ),
    );
    if (!mounted || result != 'success') return;

    await UserCubit.instance.refreshProfile();
    await widget.onSuccess?.call();
    if (!mounted) return;

    setState(() => _isSubscribed = true);
    await widget.onBeforeSuccessMessage?.call();
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

  void _selectPlan(PromotionPlanModel plan) {
    setState(() => _selectedPlanId = plan.id);
  }

  @override
  Widget build(BuildContext context) {
    return PromotionPlansStatusBuilder(
      selectedPlanId: _selectedPlanId,
      isSubscribed: _isSubscribed,
      onPlanSelected: _selectPlan,
      onSubscribe: _subscribe,
    );
  }
}
