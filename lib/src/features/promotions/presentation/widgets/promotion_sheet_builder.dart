import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/models/promotion_sheet_model.dart';
import '../cubits/promotion_sheet_cubit.dart';

typedef PromotionSheetWidgetBuilder = Widget Function(
  BuildContext context,
  BaseStatus status,
  PromotionSheetDataModel data,
);

class PromotionSheetBuilder extends StatefulWidget {
  final PromotionSheetWidgetBuilder builder;

  const PromotionSheetBuilder({
    required this.builder,
    super.key,
  });

  @override
  State<PromotionSheetBuilder> createState() => _PromotionSheetBuilderState();
}

class _PromotionSheetBuilderState extends State<PromotionSheetBuilder> {
  late final PromotionSheetCubit _promotionSheetCubit;

  @override
  void initState() {
    super.initState();
    _promotionSheetCubit = PromotionSheetCubit();
    unawaited(_promotionSheetCubit.getPromotionSheet());
  }

  @override
  void dispose() {
    unawaited(_promotionSheetCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionSheetCubit,
        AsyncState<PromotionSheetDataModel>>(
      bloc: _promotionSheetCubit,
      builder: (context, state) =>
          widget.builder(context, state.status, state.data),
    );
  }
}
