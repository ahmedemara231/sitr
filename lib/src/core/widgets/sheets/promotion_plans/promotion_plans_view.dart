import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/languages.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../features/packages/presentation/screens/subscription_screen.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/data/models/promotion_sheet_model.dart';
import '../../../../features/promotions/data/promotion_plans_data.dart';
import '../../../../features/promotions/presentation/cubits/promotion_sheet_cubit.dart';
import '../../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import '../../../extensions/widget_extension.dart';
import '../../../navigation/navigator.dart';
import '../../../shared/user_cubit/user_cubit.dart';
import '../../app_pagify.dart';
import '../../app_text.dart';
import '../../default_bottom_sheet.dart';
import '../success_sheet.dart';
import 'promotion_plan_item.dart';

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
  late final PagifyController<PromotionPlanModel> _plansController;

  List<PromotionFeatureModel> _features = [];
  int? _selectedPlanId;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _plansController = PagifyController<PromotionPlanModel>();
    unawaited(context.read<PromotionSheetCubit>().getPromotionSheet());
  }

  Future<(List<PromotionPlanModel>, PaginationData)> _getPromotionPlans(
    BuildContext _,
    int page,
  ) async {
    final PromotionPlansPageModel response =
        await PromotionPlansData.getPromotionPlans(page: page);
    if (mounted) {
      setState(() => _features = response.data.features);
    }

    return (
      response.data.plans,
      PaginationData(
        perPage: response.pagination.perPage,
        totalPages: response.pagination.totalPages,
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<PromotionSheetCubit>().getPromotionSheet(),
      _plansController.refresh(),
    ]);
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
    final PromotionSheetDataModel content =
        context.watch<PromotionSheetCubit>().state.data;
    final bool isSubscribing =
        context.watch<PromotionSubscriptionCubit>().state.isLoading;

    return AppPagify<PromotionPlanModel>(
      asyncCall: _getPromotionPlans,
      cacheKey: 'promotion_plans_${Languages.currentLanguage.languageCode}',
      cacheToJson: (plan) => plan.toJson(),
      cacheFromJson: PromotionPlanModel.fromJson,
      itemBuilder: (_, plans, index, plan) => PromotionPlanItem(
        plans: plans,
        features: _features,
        index: index,
        plan: plan,
        content: content,
        selectedPlanId: _selectedPlanId,
        isSubscribing: isSubscribing,
        isSubscribed: _isSubscribed,
        onPlanSelected: _selectPlan,
        onSubscribe: _subscribe,
      ),
      pagifyController: _plansController,
      shrinkWrap: false,
    ).withPullRefresher(onRefresh: _refresh);
  }
}
