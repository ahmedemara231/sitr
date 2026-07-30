import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/models/promotion_data_model.dart';
import '../cubits/promotion_data_cubit.dart';

typedef PromotionDataWidgetBuilder = Widget Function(
  BuildContext context,
  BaseStatus status,
  PromotionDataModel data,
);

class PromotionDataBuilder extends StatefulWidget {
  final PromotionDataWidgetBuilder builder;

  const PromotionDataBuilder({
    required this.builder,
    super.key,
  });

  @override
  State<PromotionDataBuilder> createState() => _PromotionDataBuilderState();
}

class _PromotionDataBuilderState extends State<PromotionDataBuilder> {
  late final PromotionDataCubit _promotionDataCubit;

  @override
  void initState() {
    super.initState();
    _promotionDataCubit = PromotionDataCubit();
    unawaited(_promotionDataCubit.getPromotionData());
  }

  @override
  void dispose() {
    unawaited(_promotionDataCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionDataCubit, AsyncState<PromotionDataModel>>(
      bloc: _promotionDataCubit,
      builder: (context, state) => widget.builder(context, state.status, state.data),
    );
  }
}
