import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/packages/presentation/packages_screen.dart';
import '../../features/promotions/data/models/promotion_badge_model.dart';
import '../helpers/helpers.dart';
import '../navigation/Constants/imports_constants.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/user_model.dart';
import 'app_text.dart';
import 'icon_widget.dart';

class PromotionBadge extends StatelessWidget {
  static const double height = 52;
  static const double width = 220;

  final FutureOr<void> Function()? onSuccess;
  final PromotionBadgeDataModel data;

  const PromotionBadge({
    super.key,
    this.onSuccess,
    this.data = const PromotionBadgeDataModel.initial(),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(26.r),
      child: InkWell(
        onTap: () => UserModel.isAuthenticated
            ? Go.to(
                PackagesScreen.promotion(onSuccess: onSuccess),
                transition: TransitionType.slide,
              )
            : Helpers.showUnauthenticatedSheet(),
        borderRadius: BorderRadius.circular(26.r),
        child: _PromotionBadgeSurface(
          textBlock: _PromotionTextBlock(data: data),
          trailing: _PromotionActionPill(data: data),
        ),
      ),
    );
  }
}

class PromotedBadge extends StatelessWidget {
  final PromotionBadgeDataModel data;

  const PromotedBadge({
    super.key,
    this.data = const PromotionBadgeDataModel.initial(),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _contentOrFallback(data.title, LocaleKeys.promotedBadgeTitle),
      excludeSemantics: true,
      child: Material(
        color: AppColors.transparent,
        child: _PromotionBadgeSurface(
          textBlock: _PromotedTextBlock(data: data),
          trailing: _PromotedStatusPill(data: data),
        ),
      ),
    );
  }
}

class _PromotionBadgeSurface extends StatelessWidget {
  final Widget textBlock;
  final Widget trailing;

  const _PromotionBadgeSurface({
    required this.textBlock,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PromotionBadge.width.w,
      height: PromotionBadge.height.h,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              AppColors.promotionBadgeGradientStart,
              AppColors.promotionBadgeGradientMiddle,
              AppColors.promotionBadgeGradientEnd,
            ],
            stops: [0, 0.4, 1],
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.promotionBadgeShadow.withValues(alpha: 0.25),
              blurRadius: 4.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26.r),
          child: Stack(
            children: [
              PositionedDirectional(
                top: -18.h,
                end: -8.w,
                child: const _PromotionSheen(),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  10.w,
                  10.h,
                  8.w,
                  10.h,
                ),
                child: Row(
                  children: [
                    const _PromotionIcon(),
                    SizedBox(width: 10.w),
                    Expanded(child: textBlock),
                    SizedBox(width: 8.w),
                    trailing,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromotionSheen extends StatelessWidget {
  const _PromotionSheen();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 72.h,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: AlignmentDirectional.topEnd,
          colors: [
            AppColors.promotionBadgeGlow.withValues(alpha: 0.18),
            AppColors.transparent,
          ],
        ),
      ),
    );
  }
}

class _PromotionIcon extends StatelessWidget {
  const _PromotionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.18),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.28),
        ),
      ),
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size.square(16.r),
        painter: const _PromotionCrownPainter(),
      ),
    );
  }
}

class _PromotionCrownPainter extends CustomPainter {
  const _PromotionCrownPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 16;
    final Paint crownPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    final Paint crownBorderPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4 * scale;
    final Path crown = Path()
      ..moveTo(2.5 * scale, 11 * scale)
      ..lineTo(13.5 * scale, 11 * scale)
      ..lineTo(12 * scale, 5 * scale)
      ..lineTo(9.5 * scale, 8 * scale)
      ..lineTo(8 * scale, 4 * scale)
      ..lineTo(6.5 * scale, 8 * scale)
      ..lineTo(4 * scale, 5 * scale)
      ..close();
    final RRect crownBase = RRect.fromRectAndRadius(
      Rect.fromLTWH(2.5 * scale, 11.5 * scale, 11 * scale, 1.5 * scale),
      Radius.circular(0.75 * scale),
    );

    canvas
      ..drawPath(crown, crownPaint)
      ..drawPath(crown, crownBorderPaint)
      ..drawRRect(
        crownBase,
        Paint()..color = AppColors.white.withValues(alpha: 0.7),
      );
  }

  @override
  bool shouldRepaint(covariant _PromotionCrownPainter oldDelegate) => false;
}

class _PromotionTextBlock extends StatelessWidget {
  final PromotionBadgeDataModel data;

  const _PromotionTextBlock({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          _contentOrFallback(data.title, LocaleKeys.promotionBadgeTitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        SizedBox(height: 1.h),
        AppText(
          _contentOrFallback(data.subtitle, LocaleKeys.promotionBadgeSubtitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 10.sp,
          height: 1,
        ),
      ],
    );
  }
}

class _PromotionActionPill extends StatelessWidget {
  final PromotionBadgeDataModel data;

  const _PromotionActionPill({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      constraints: BoxConstraints(maxWidth: 80.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: AppText(
        _contentOrFallback(
          data.actionText,
          LocaleKeys.promotionBadgeAction,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: AppColors.promotionBadgeGradientEnd,
        fontSize: 11.5.sp,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}

class _PromotedTextBlock extends StatelessWidget {
  final PromotionBadgeDataModel data;

  const _PromotedTextBlock({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          _contentOrFallback(data.title, LocaleKeys.promotedBadgeTitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        SizedBox(height: 1.h),
        AppText(
          _contentOrFallback(data.subtitle, LocaleKeys.promotedBadgeSubtitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 10.sp,
          height: 1,
        ),
      ],
    );
  }
}

class _PromotedStatusPill extends StatelessWidget {
  final PromotionBadgeDataModel data;

  const _PromotedStatusPill({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      constraints: BoxConstraints(maxWidth: 80.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconWidget(
            icon: Icons.verified_rounded,
            color: AppColors.promotionBadgeGradientEnd,
            width: 13.sp,
            height: 13.sp,
          ),
          SizedBox(width: 4.w),
          AppText(
            _contentOrFallback(
              data.actionText,
              LocaleKeys.promotedBadgeStatus,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.promotionBadgeGradientEnd,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ],
      ),
    );
  }
}

String _contentOrFallback(String content, String fallback) =>
    content.trim().isEmpty ? fallback : content;
