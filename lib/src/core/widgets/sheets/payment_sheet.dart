import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/padding_extension.dart';
import '../app_text.dart';
import '../buttons/custom_app_buttons/default_button.dart';
import '../svg_pic.dart';

class PaymentSheet extends StatelessWidget {
  final Future<void> Function() onPay;
  const PaymentSheet({super.key,
    required this.onPay
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppText(LocaleKeys.packagePaymentValue, fontSize: 16.sp, fontWeight: FontWeight.bold),
        AppText(LocaleKeys.chooseASuitablePaymentMethodFromTheAvailableOnes),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary)
          ),
          child: Center(
            child: const SvgPic(assetName: Assets.svgOnlinePayment).paddingAll(20),
          ),
        ),
        AppDefaultButton.withBackGroundColor(
            title: LocaleKeys.pay,
            onTap: ()async => await onPay.call()
        )
      ],
    );
  }
}
