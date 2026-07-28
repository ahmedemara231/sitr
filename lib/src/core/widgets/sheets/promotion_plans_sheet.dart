import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/chats/data/chat_sheet_manager.dart';
import '../../../features/promotions/presentation/cubits/promotion_plans_cubit.dart';
import '../../../features/promotions/presentation/cubits/promotion_subscription_cubit.dart';
import 'promotion_plans_sheet/promotion_plans_sheet_body.dart';

Future<void> showPromotionPlansSheet({
  FutureOr<void> Function()? onSuccess,
}) async {
  await ChatSheetManager.show(
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PromotionPlansCubit(),
        ),
        BlocProvider(
          create: (_) => PromotionSubscriptionCubit(),
        ),
      ],
      child: PromotionPlansSheetBody(onSuccess: onSuccess),
    ),
  );
}
