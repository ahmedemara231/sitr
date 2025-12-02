import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/riyal_price_text.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../models/package.dart';
import '../cubits/subscribe_to_package.dart';
import '../packages_screen.dart';
import '../screens/subscription_screen.dart';
import 'package:saudi_currency/saudi_currency.dart';

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
                  child: Builder(
                    builder: (context) {
                      return AppDefaultButton.withBorderColor(
                          title: type == ScreenType.first?
                          LocaleKeys.subscribeToPackage : LocaleKeys.renewPackage,
                          onTap: () => !package.canSubscribe?
                          MessageUtils.showSnackBar(LocaleKeys.youAreAlreadySubscribedInPackage) :
                          showDefaultBottomSheet(
                              child: PaymentSheet(
                                paymentMethods: paymentMethods,
                                onPay: (ctx, paymentMethod) async => context.read<PackagesManagerCubit>().subscribeOrRenewPackage(
                                  packageId: package.id.toString(),
                                  type: type,
                                  paymentMethod: paymentMethod,
                                  onSuccess: (url) async{
                                    Object? result = '';

                                    if(paymentMethod == PaymentMethod.online){
                                      result = await Go.to(SubscriptionScreen(
                                          initialUrl: url,
                                          title: LocaleKeys.pay
                                      ));
                                    }else if(paymentMethod == PaymentMethod.wallet){
                                      result = 'success';
                                    }

                                    if(result == 'success'){
                                      showDefaultBottomSheet(
                                          child: SuccessSheet(
                                            isInAuth: isInAuth,
                                            upperText: Column(
                                              spacing: 10.h,
                                              children: [
                                                AppText(
                                                    LocaleKeys.paymentSucceeded,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                AppText(LocaleKeys.youCanNowCompleteYourProfile),
                                              ],
                                            ),
                                          )
                                      );
                                    }
                                  }
                                )
                              )
                          )
                      );
                    }
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
