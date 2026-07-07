import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../features/packages/presentation/screens/subscription_screen.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../../../features/promotions/data/models/promotion_subscription_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_plans_cubit.dart';
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
  const PromotionPlansSheetBody({super.key});

  @override
  State<PromotionPlansSheetBody> createState() =>
      _PromotionPlansSheetBodyState();
}

class _PromotionPlansSheetBodyState extends State<PromotionPlansSheetBody> {
  int? _selectedPlanId;
  bool _isSubscribed = false;

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
      if (!mounted) return;

      setState(() => _isSubscribed = true);
      Navigator.of(context).pop();
      await Future<void>.delayed(const Duration(milliseconds: 250));
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
    final double maxSheetHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
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
                  const PromotionSheetHeader(),
                  Flexible(
                    child: BlocBuilder<PromotionPlansCubit,
                        AsyncState<PromotionPlansModel>>(
                      builder: (context, state) {
                        final PromotionPlansModel data = state.data;
                        if ((state.isLoading || state.isInitial) &&
                            data.plans.isEmpty) {
                          return const PromotionPlansLoading();
                        }

                        if (data.plans.isEmpty) {
                          return PromotionPlansError(
                            message: state.msg,
                            onRetry: () => context
                                .read<PromotionPlansCubit>()
                                .getPromotionPlans(),
                          );
                        }

                        return BlocBuilder<PromotionSubscriptionCubit,
                            AsyncState<PromotionSubscriptionModel>>(
                          builder: (context, subscriptionState) =>
                              PromotionPlansContent(
                            data: data,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
