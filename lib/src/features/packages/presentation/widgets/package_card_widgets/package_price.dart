import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/extensions/text_style_extensions.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/riyal_price_text.dart';

class PackagePrice extends StatelessWidget {
  final num price;

  const PackagePrice({required this.price, super.key});

  String get _priceText =>
      price % 1 == 0 ? price.toInt().toString() : price.toString();

  @override
  Widget build(BuildContext context) {
    final TextStyle priceStyle = const TextStyle(
      fontFamily: ConstantManager.fontFamily,
    ).s24.bold.copyWith(color: AppColors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText(
          LocaleKeys.price,
          color: AppColors.white.withValues(alpha: 0.78),
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        2.szH,
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerEnd,
          child: RiyalPriceText(
            price: _priceText,
            priceTextStyle: priceStyle,
            currencyTextStyle: priceStyle,
          ),
        ),
      ],
    );
  }
}
