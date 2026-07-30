import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/packages/presentation/packages_screen.dart';
import '../../features/promotions/data/models/promotion_data_model.dart';
import '../../../generated/assets.dart';
import '../helpers/helpers.dart';
import '../navigation/Constants/imports_constants.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/user_model.dart';
import 'app_text.dart';
import 'icon_widget.dart';

class PromotionBadge extends StatelessWidget {
  static const double height = 86;

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
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => UserModel.isAuthenticated? Go.to(
          PackagesScreen.promotion(onSuccess: onSuccess),
          transition: TransitionType.slide,
        ) : Helpers.showUnauthenticatedSheet(),
        borderRadius: BorderRadius.circular(10.r),
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
    return Ink(
      height: PromotionBadge.height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.06),
            blurRadius: 24.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -34.h,
              end: -18.w,
              child: const _PromotionDecorationCircle(dimension: 108),
            ),
            PositionedDirectional(
              bottom: -42.h,
              start: 92.w,
              child: const _PromotionDecorationCircle(dimension: 82),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                14.w,
                12.h,
                12.w,
                12.h,
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
    );
  }
}

class _PromotionDecorationCircle extends StatelessWidget {
  final double dimension;

  const _PromotionDecorationCircle({required this.dimension});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension.r,
      height: dimension.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.07),
      ),
    );
  }
}

class _PromotionIcon extends StatelessWidget {
  const _PromotionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.16),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        alignment: Alignment.center,
        child: IconWidget(
          icon: Assets.svgPackagesScreenImage,
          width: 23.w,
          height: 25.h,
        ),
      ),
    );
  }
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
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        SizedBox(height: 4.h),
        AppText(
          _contentOrFallback(data.subtitle, LocaleKeys.promotionBadgeSubtitle),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          height: 1.25,
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
      padding: EdgeInsetsDirectional.fromSTEB(10.w, 7.h, 8.w, 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            _contentOrFallback(
              data.actionText,
              LocaleKeys.promotionBadgeAction,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.primary,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          SizedBox(width: 3.w),
          IconWidget(
            icon: Icons.arrow_forward_ios_rounded,
            color: AppColors.primary,
            width: 11.sp,
            height: 11.sp,
          ),
        ],
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
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        SizedBox(height: 4.h),
        AppText(
          _contentOrFallback(data.subtitle, LocaleKeys.promotedBadgeSubtitle),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          height: 1.25,
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
      padding: EdgeInsetsDirectional.fromSTEB(8.w, 7.h, 10.w, 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconWidget(
            icon: Icons.verified_rounded,
            color: AppColors.primary,
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
            color: AppColors.primary,
            fontSize: 11.sp,
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
