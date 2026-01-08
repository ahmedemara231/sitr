import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/shared/get_paymeny_brands_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/riyal_price_text.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../models/package.dart';
import '../cubits/subscribe_to_package.dart';
import '../packages_screen.dart';

class PackageWidget extends StatelessWidget {
  final Package package;
  final ScreenType type;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;

  const PackageWidget({super.key,
    required this.type,
    required this.package,
    this.paymentMethods,
    this.isInAuth = false,
  });

  Future<void> _subscribeOrRenew(BuildContext context, {
    required PaymentMethod method,
    int? bId,
    void Function(String url)? onSuccessOnline,
    void Function()? onSuccessWallet,
  })async{
    await context.read<PackagesManagerCubit>().subscribeOrRenewPackage(
        brandId: bId,
        package: package,
        type: type,
        paymentMethod: method,
        onSuccess: (url) async{
          if(method == PaymentMethod.online){
            onSuccessOnline?.call(url);

          }else{
            onSuccessWallet?.call();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteGreyColorProMax,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteGreyColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CachedImage(url: package.image).paddingAll(10.r)),
            title: AppText(package.name, fontWeight: FontWeight.bold, fontSize: 16.sp,),
            subtitle: Row(
              spacing: 5.w,
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppColors.primary,),
                AppText('${package.duration} ${LocaleKeys.day}', color: AppColors.primary,)
              ],
            ),
          ),
          Row(
            spacing: 7.w,
            children: [
              FittedBox(child: AppText(LocaleKeys.price, color: Colors.grey)),
              RiyalPriceText(price: package.price.toString(), priceTextStyle: const TextStyle(color: Colors.black)),

              const Spacer(),
              SizedBox(
                width: context.width * .4,
                height: 40.h,
                child: BlocProvider(
                  create: (context) => PackagesManagerCubit(),
                  child: AppDefaultButton.withBorderColor(
                      title: type == ScreenType.subscription?
                      LocaleKeys.subscribeToPackage : LocaleKeys.renewPackage,
                      onTap: () async => package.hasActivePackage?
                      MessageUtils.showSnackBar(LocaleKeys.youAreAlreadySubscribedInPackage) :
                      ChatSheetManager.show(
                        child: Helpers.handlePaymentSheet(
                          bloc: PackagesManagerCubit(),
                          isInAuth: isInAuth,
                          paymentMethods: paymentMethods,
                          onPayWallet: (ctx, onSuccess) async => await _subscribeOrRenew(
                              ctx,
                              method: PaymentMethod.wallet,
                              onSuccessWallet: () => onSuccess.call()
                          ),
                          onPayOnline: (ctx, bId, onSuccess) async => await _subscribeOrRenew(
                              ctx,
                              method: PaymentMethod.online,
                              bId: bId,
                              onSuccessOnline: onSuccess
                          ),
                          upperWidget: Column(
                            spacing: 10.h,
                            children: [
                              AppText(
                                  LocaleKeys.paymentSucceeded,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold
                              ),
                              if(isInAuth)
                                AppText(LocaleKeys.youCanNowCompleteYourProfile),
                            ],
                          ),
                        )
                      )

                      // showDefaultBottomSheet(
                      //     child: PaymentSheet(
                      //       paymentMethods: paymentMethods,
                      //       onPay: (ctx, paymentMethod) async =>
                      //       paymentMethod == PaymentMethod.online?
                      //       Helpers.executeOnlinePayment(
                      //         context,
                      //         upperWidget: Column(
                      //           spacing: 10.h,
                      //           children: [
                      //             AppText(
                      //                 LocaleKeys.paymentSucceeded,
                      //                 fontSize: 16.sp,
                      //                 fontWeight: FontWeight.bold
                      //             ),
                      //
                      //             if(isInAuth)
                      //               AppText(LocaleKeys.youCanNowCompleteYourProfile),
                      //           ],
                      //         ),
                      //         onPay: (context, brandId, Function(String url) onSuccess) async
                      //             => _makePackagePayment(
                      //                 context,
                      //                 brandId: brandId,
                      //                 paymentMethod: paymentMethod,
                      //                 onSuccess: (String url) => onSuccess.call(url)
                      //             ),
                      //       ) : _makePackagePayment(
                      //           context,
                      //           paymentMethod: paymentMethod,
                      //       )
                      //     )
                      // )
                  ),
                ),
              )
            ],
          )
        ],
      ).paddingAll(16.r)

    );
  }
}
