import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/models/promotion_badge_model.dart';
import '../cubits/promotion_badge_cubit.dart';

typedef PromotionBadgeWidgetBuilder = Widget Function(
  BuildContext context,
  BaseStatus status,
  PromotionBadgeDataModel data,
);

class PromotionBadgeBuilder extends StatefulWidget {
  final bool isPromoted;
  final PromotionBadgeWidgetBuilder builder;

  const PromotionBadgeBuilder({
    required this.isPromoted,
    required this.builder,
    super.key,
  });

  @override
  State<PromotionBadgeBuilder> createState() => _PromotionBadgeBuilderState();
}

class _PromotionBadgeBuilderState extends State<PromotionBadgeBuilder> {
  late final PromotionBadgeCubit _promotionBadgeCubit;

  @override
  void initState() {
    super.initState();
    _promotionBadgeCubit = PromotionBadgeCubit();
    unawaited(
      _promotionBadgeCubit.getPromotionBadge(
        isPromoted: widget.isPromoted,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_promotionBadgeCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionBadgeCubit,
        AsyncState<PromotionBadgeDataModel>>(
      bloc: _promotionBadgeCubit,
      builder: (context, state) =>
          widget.builder(context, state.status, state.data),
    );
  }
}
