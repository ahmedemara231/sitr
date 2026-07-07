import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/res/config_imports.dart';
import '../../../features/promotions/presentation/cubits/promotion_plans_cubit.dart';
import '../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import 'promotion_plans_sheet/promotion_plans_sheet_body.dart';

Future<void> showPromotionPlansSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: false,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.blackShadow.withValues(alpha: 0.45),
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PromotionPlansCubit()..getPromotionPlans(),
        ),
        BlocProvider(
          create: (_) => PromotionSubscriptionCubit(),
        ),
      ],
      child: const PromotionPlansSheetBody(),
    ),
  );
}
