import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../helpers/status_builder.dart';
import '../../shared/get_paymeny_brands_cubit.dart';
import '../../shared/models/payment_brand.dart';
import '../app_text.dart';
import '../image_widgets/cached_image.dart';
import '../radio_bottom_sheet.dart';

class ShowBrandsSheet extends StatelessWidget {
  final Function(BuildContext context, int brandId) onPay;
  const ShowBrandsSheet({super.key, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBrandsCubit()..get(),
      child: BlocBuilder<PaymentBrandsCubit, AsyncState<List<PaymentBrand>>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (data, context) => IntrinsicHeight(
            child: RadioSelectionWidget<int>(
                selectedBackgroundColor: AppColors.primary.withOpacity(.2),
                title: LocaleKeys.choosePaymentMethod,
                onSubmit: (ctx, brandId) async => await onPay.call(ctx, brandId),
                values: data.map((e) => e.id??0).toList(),
                showSubmitButton: true,
                titles: List.generate(
                    data.length,
                        (i) => Expanded(child: Row(
                      spacing: 10.w,
                      children: [
                        CachedImage(
                            width: 50.w,
                            height: 50.h,
                            url: data[i].image??''
                        ),
                        AppText(data[i].name??''),
                      ],
                    ))
                )
            ),
          ),
        ),
      ),
    );
  }
}
