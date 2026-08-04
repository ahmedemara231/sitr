import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/extensions/text_style_extensions.dart';
import '../../../../core/helpers/apps_flyer/apps_flyer_helper.dart';
import '../../../../core/helpers/apps_flyer/events.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/riyal_price_text.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../../../core/widgets/sheets/show_brands_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../models/package.dart';
import '../cubits/subscribe_to_package.dart';
import '../models/package_screen_type.dart';
import '../screens/subscription_screen.dart';

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
        await _showPaymentBrands(context);
        return;
      case PaymentMethod.wallet:
        await _payWithWallet(context);
        return;
    }
  }

  Future<void> _showPaymentBrands(BuildContext context) async {
    final PackagesManagerCubit cubit = context.read<PackagesManagerCubit>();

    await ChatSheetManager.show(
      child: BlocProvider.value(
        value: cubit,
        child: ShowBrandsSheet(onPay: _payOnline),
      ),
    );
  }

  Future<void> _payOnline(BuildContext context, int brandId) async {
    await context.read<PackagesManagerCubit>().subscribeOrRenewPackage(
          package: package,
          type: type,
          brandId: brandId,
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
    if (result != 'success') return;

    await _handlePaymentSuccess(shouldTrackPayment: true);
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
        upperText: _PackageSuccessMessage(isInAuth: isInAuth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String actionTitle = type.isSubscription
        ? LocaleKeys.subscribeToPackage
        : LocaleKeys.renewPackage;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.06),
            blurRadius: 64.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            _PackageHero(package: package),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _PackageFactsPanel(package: package),
                  16.szH,
                  _PackageActionButton(
                    title: actionTitle,
                    isSecondary: package.hasActivePackage,
                    onPressed: () => _handleActionPressed(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageHero extends StatelessWidget {
  final Package package;

  const _PackageHero({required this.package});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 108.h),
          decoration: const BoxDecoration(
            color: AppColors.whiteGreyColor,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
        ),
        PositionedDirectional(
          top: -48.r,
          end: -24.r,
          child: const _PackageDecorationCircle(size: 132),
        ),
        PositionedDirectional(
          bottom: -34.r,
          end: 74.r,
          child: const _PackageDecorationCircle(size: 72),
        ),
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              _PackageArtwork(imageUrl: package.image),
              14.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      package.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textBlack,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.35,
                    ),
                    if (package.type.title.trim().isNotEmpty) ...[
                      10.szH,
                      _PackageTypeBadge(title: package.type.title),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PackageDecorationCircle extends StatelessWidget {
  final double size;

  const _PackageDecorationCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.07),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _PackageTypeBadge extends StatelessWidget {
  final String title;

  const _PackageTypeBadge({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: 190.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.promotionBadgeGradientStart,
              AppColors.promotionBadgeGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.promotionBadgeShadow.withValues(alpha: 0.14),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconWidget(
              icon: Icons.workspace_premium_outlined,
              color: AppColors.white,
              width: 14.r,
              height: 14.r,
            ),
            5.szW,
            Flexible(
              child: AppText(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppColors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageArtwork extends StatelessWidget {
  final String imageUrl;

  const _PackageArtwork({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76.r,
      height: 76.r,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: CachedImage(
        url: imageUrl,
        fit: BoxFit.contain,
        bgColor: AppColors.transparent,
        borderColor: AppColors.transparent,
        placeHolder: SvgPic(
          assetName: Assets.svgPackagesScreenImage,
          size: 46.r,
        ),
      ),
    );
  }
}

class _PackageFactsPanel extends StatelessWidget {
  final Package package;

  const _PackageFactsPanel({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.09),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PackageFact(
              icon: Icons.calendar_month_outlined,
              value: '${package.duration} ${LocaleKeys.day}',
            ),
          ),
          Container(
            width: 1.w,
            height: 36.h,
            color: AppColors.primary.withValues(alpha: 0.16),
          ),
          Expanded(child: _PackagePrice(price: package.price)),
        ],
      ),
    );
  }
}

class _PackageFact extends StatelessWidget {
  final IconData icon;
  final String value;

  const _PackageFact({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Center(
            child: IconWidget(
              icon: icon,
              color: AppColors.primary,
              width: 17.r,
              height: 17.r,
            ),
          ),
        ),
        8.szW,
        Flexible(
          child: AppText(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.darkGray,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PackagePrice extends StatelessWidget {
  final num price;

  const _PackagePrice({required this.price});

  String get _priceText =>
      price % 1 == 0 ? price.toInt().toString() : price.toString();

  @override
  Widget build(BuildContext context) {
    final TextStyle priceStyle = const TextStyle(
      fontFamily: ConstantManager.fontFamily,
    ).s20.bold.setPrimaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          LocaleKeys.price,
          color: AppColors.darkGay,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        3.szH,
        FittedBox(
          fit: BoxFit.scaleDown,
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

class _PackageActionButton extends StatelessWidget {
  final String title;
  final bool isSecondary;
  final VoidCallback onPressed;

  const _PackageActionButton({
    required this.title,
    required this.isSecondary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor =
        isSecondary ? AppColors.primary : AppColors.white;

    return DefaultButton(
      width: double.infinity,
      height: 52.h,
      borderRadius: BorderRadius.circular(50.r),
      color: isSecondary ? AppColors.white : AppColors.primary,
      borderColor: AppColors.primary,
      onTap: onPressed,
      customChild: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            title,
            color: contentColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          8.szW,
          IconWidget(
            icon: Icons.arrow_forward_rounded,
            color: contentColor,
            width: 18.r,
            height: 18.r,
          ),
        ],
      ),
    );
  }
}

class _PackageSuccessMessage extends StatelessWidget {
  final bool isInAuth;

  const _PackageSuccessMessage({required this.isInAuth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          LocaleKeys.paymentSucceeded,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        if (isInAuth) ...[
          10.szH,
          AppText(LocaleKeys.youCanNowCompleteYourProfile),
        ],
      ],
    );
  }
}
