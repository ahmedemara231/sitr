import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/helpers/apps_flyer/apps_flyer_helper.dart';
import '../../../../core/helpers/apps_flyer/events.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../../../core/widgets/sheets/show_brands_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../models/package.dart';
import '../cubits/subscribe_to_package.dart';
import '../models/package_screen_type.dart';
import '../screens/subscription_screen.dart';
import 'package_card_widgets/package_action_footer.dart';
import 'package_card_widgets/package_card_theme.dart';
import 'package_card_widgets/package_pass_header.dart';
import 'package_card_widgets/package_success_message.dart';

class PackageWidget extends StatelessWidget {
  final Package package;
  final ScreenType type;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;
  final void Function() onSubscribe;

  const PackageWidget({
    required this.type,
    required this.package,
    required this.onSubscribe,
    this.paymentMethods,
    this.isInAuth = false,
    super.key,
  });

  Future<void> _handleActionPressed(BuildContext context) async {
    if (package.hasActivePackage) {
      MessageUtils.show(
        LocaleKeys.youHaveActivePackageNow,
        state: MsgState.info,
      );
      return;
    }

    await ChatSheetManager.show(
      child: BlocProvider(
        create: (_) => PackagesManagerCubit(),
        child: PaymentSheet(
          paymentMethods: paymentMethods,
          onPay: _handlePayment,
        ),
      ),
    );
  }

  Future<void> _handlePayment(
    BuildContext context,
    PaymentMethod paymentMethod,
  ) async {
    switch (paymentMethod) {
      case PaymentMethod.online:
        await _payOnline(context);
        // await _showPaymentBrands(context);
        return;
      case PaymentMethod.wallet:
        await _payWithWallet(context);
        return;
    }
  }

  // Future<void> _showPaymentBrands(BuildContext context) async {
  //   final PackagesManagerCubit cubit = context.read<PackagesManagerCubit>();
  //
  //   await ChatSheetManager.show(
  //     child: BlocProvider.value(
  //       value: cubit,
  //       child: ShowBrandsSheet(onPay: _payOnline),
  //     ),
  //   );
  // }

  Future<void> _payOnline(BuildContext context) async {
    await context.read<PackagesManagerCubit>().subscribeOrRenewPackage(
          package: package,
          type: type,
          paymentMethod: PaymentMethod.online,
          onSuccess: (String url) => unawaited(_openOnlinePayment(url)),
        );
  }

  Future<void> _openOnlinePayment(String url) async {
    final Object? result = await Go.to(
      SubscriptionScreen(
        initialUrl: url,
        title: LocaleKeys.pay,
      ),
    );

    log('the payment result is $result');
    if (result == 'success'){
      await _handlePaymentSuccess(shouldTrackPayment: true);
    }
  }

  Future<void> _payWithWallet(BuildContext context) async {
    await context.read<PackagesManagerCubit>().subscribeOrRenewPackage(
          package: package,
          type: type,
          paymentMethod: PaymentMethod.wallet,
          onSuccess: (_) => unawaited(
            _handlePaymentSuccess(shouldTrackPayment: false),
          ),
        );
  }

  Future<void> _handlePaymentSuccess({
    required bool shouldTrackPayment,
  }) async {
    onSubscribe();
    if (shouldTrackPayment) {
      await AppyFlyerHelper.logEvent(FlyerEvents.pay);
    }

    await ChatSheetManager.show(
      child: SuccessSheet(
        isInAuth: isInAuth,
        upperText: PackageSuccessMessage(isInAuth: isInAuth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String actionTitle = type.isSubscription
        ? LocaleKeys.subscribeToPackage
        : LocaleKeys.renewPackage;
    final PackageCardTheme cardTheme =
        PackageCardTheme.fromPrice(package.price);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: cardTheme.accent.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: cardTheme.accent.withValues(alpha: 0.12),
            blurRadius: 28.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            PackagePassHeader(package: package, cardTheme: cardTheme),
            PackageActionFooter(
              title: actionTitle,
              isSecondary: package.hasActivePackage,
              accentColor: cardTheme.accent,
              onPressed: () => _handleActionPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
