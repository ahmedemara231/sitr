import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/presentation/cubits/promotion_data_cubit.dart';
import '../../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import 'promotion_sheet_chrome.dart';

class PromotionPlansHeaderBuilder extends StatelessWidget {
  final bool showCloseButton;

  const PromotionPlansHeaderBuilder({
    this.showCloseButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PromotionDataCubit, AsyncState<PromotionDataModel>,
        PromotionSheetDataModel>(
      selector: (AsyncState<PromotionDataModel> state) =>
          state.data.promotionSheet,
      builder: (BuildContext context, PromotionSheetDataModel data) {
        return PromotionSheetHeader(
          data: data,
          showCloseButton: showCloseButton,
        );
      },
    );
  }
}
