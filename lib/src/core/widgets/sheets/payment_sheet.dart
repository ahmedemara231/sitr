import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/padding_extension.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';
import '../svg_pic.dart';

class PaymentSheet extends StatefulWidget {
  final List<PaymentMethod>? paymentMethods;
  final Future<void> Function(BuildContext context, PaymentMethod paymentMethod) onPay;
  const PaymentSheet({super.key,
    required this.onPay,
    this.paymentMethods,
  });

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  int currentIndex = 0;
  PaymentMethod paymentMethod = PaymentMethod.online;
  void _changeIndex(int newIndex){
    setState(() => currentIndex = newIndex);
    paymentMethod = newIndex.getPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final methods = widget.paymentMethods ?? PaymentMethod.values;
    return Column(
      spacing: 12.h,
      children: [
        AppText(LocaleKeys.packagePaymentValue, fontSize: 16.sp, fontWeight: FontWeight.bold),
        AppText(LocaleKeys.chooseASuitablePaymentMethodFromTheAvailableOnes),
        Column(
          spacing: 7.h,
          children: List.generate(
            methods.length,
                (index) => InkWell(
              onTap: () => _changeIndex(index),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        width: currentIndex == index? 1 : .2,
                        color: currentIndex == index ?
                        AppColors.primary : Colors.grey
                    )
                ),
                child: Center(
                  child: _PackageCard(
                      paymentMethod: methods[index]
                  ).paddingAll(12.r),
                ),
              ),
            ),
          ),
        ),
        AppLoadingButton(
          asyncCall: (context)async => await widget.onPay.call(context, paymentMethod),
          title: LocaleKeys.pay,
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  const _PackageCard({required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPic(assetName: paymentMethod.image),
        AppText(paymentMethod.getPaymentMethodAsString, fontWeight: FontWeight.bold,)
      ],
    );
  }
}

enum PaymentMethod {
  online(0, Assets.svgOnlinePayment),
  wallet(1, Assets.svgWalletPay);

  final int id;
  final String image;
  const PaymentMethod(this.id, this.image);
}

extension GetPayMethod on int{
  PaymentMethod get getPaymentMethod{
    switch(this){
      case 0:
        return PaymentMethod.online;

      default:
        return PaymentMethod.wallet;
    }
  }
}

extension GetPayMethodAsString on PaymentMethod{
  String get getPaymentMethodAsString{
    switch(this){
      case PaymentMethod.online:
        return LocaleKeys.onlinePayment;

      case PaymentMethod.wallet:
        return LocaleKeys.wallet;

      // default:
      //   return '';
    }
  }
}