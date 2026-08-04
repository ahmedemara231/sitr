import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/navigation/Constants/imports_constants.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/shared/base_state.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../../core/widgets/icon_widget.dart';
import '../../packages/presentation/packages_screen.dart';
import '../../promotions/data/models/promotion_plans_model.dart';
import '../../promotions/presentation/widgets/promotion_badge_builder.dart';

Future<void> showPremiumUpgradeCardDialog() async {
  await showDialog<void>(
    context: Go.context,
    barrierColor: AppColors.blackShadow.withValues(alpha: 0.55),
    builder: (_) => const PremiumUpgradeCardDialog(),
  );
}

class PremiumUpgradeCardDialog extends StatelessWidget {
  const PremiumUpgradeCardDialog({super.key});

  List<PromotionFeatureModel> get _features => [
        PromotionFeatureModel(
          id: 0,
          code: 'golden_verification',
          title: LocaleKeys.premiumUpgradeCardVerification,
          sortOrder: 1,
        ),
        PromotionFeatureModel(
          id: 0,
          code: 'speed',
          title: LocaleKeys.premiumUpgradeCardSpeed,
          sortOrder: 2,
        ),
      ];

  void _openPromotionPlans() {
    Go.back();
    Go.to(
      const PackagesScreen.promotion(),
      transition: TransitionType.slide,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PromotionBadgeBuilder(
      isPromoted: false,
      builder: (context, status, data) {
        final String title = _contentOrFallback(
          data.title,
          LocaleKeys.promotionBadgeTitle,
        );

        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          backgroundColor: AppColors.transparent,
          child: status.isLoading
              ? CustomLoading.showLoadingView()
              : SingleChildScrollView(
                  child: Semantics(
                    container: true,
                    label: title,
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                          colors: [
                            AppColors.promotionBadgeGradientStart,
                            AppColors.primary,
                            AppColors.promotionBadgeGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.promotionBadgeShadow
                                .withValues(alpha: 0.2),
                            blurRadius: 30.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          PositionedDirectional(
                            top: -48.h,
                            end: -48.w,
                            child: const _PremiumAtmosphericCircle(
                              dimension: 192,
                              color: AppColors.darkGoldenRod,
                              opacity: 0.3,
                              blurRadius: 24,
                            ),
                          ),
                          PositionedDirectional(
                            bottom: -32.h,
                            start: -32.w,
                            child: const _PremiumAtmosphericCircle(
                              dimension: 128,
                              color: AppColors.promotionBadgeGradientStart,
                              opacity: 0.4,
                              blurRadius: 18,
                            ),
                          ),
                          PositionedDirectional(
                            top: 16.h,
                            end: 16.w,
                            child: const _PremiumDashedRing(),
                          ),
                          const Positioned.fill(child: _PremiumShimmer()),
                          Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _PremiumBadgeIcon(),
                                SizedBox(height: 16.h),
                                _PremiumCardCopy(
                                  title: title,
                                  subtitle: _contentOrFallback(
                                    data.subtitle,
                                    LocaleKeys.premiumUpgradeCardSubtitle,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                _PremiumBenefits(features: _features),
                                SizedBox(height: 24.h),
                                _PremiumActionButton(
                                  title: _contentOrFallback(
                                    data.actionText,
                                    LocaleKeys.promotionBadgeAction,
                                  ),
                                  onActionPressed: _openPromotionPlans,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _PremiumBadgeIcon extends StatelessWidget {
  const _PremiumBadgeIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
        ),
      ),
      child: IconWidget(
        icon: Icons.workspace_premium_rounded,
        color: AppColors.white,
        width: 30.r,
        height: 30.r,
      ),
    );
  }
}

class _PremiumCardCopy extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PremiumCardCopy({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          color: AppColors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
        SizedBox(height: 8.h),
        AppText(
          subtitle,
          color: AppColors.promotionBadgeSubtitle,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ],
    );
  }
}

class _PremiumBenefits extends StatelessWidget {
  final List<PromotionFeatureModel> features;

  const _PremiumBenefits({
    required this.features,
  });

  IconData _getFeatureIcon(String code) {
    final String normalizedCode = code.toLowerCase();
    if (normalizedCode.contains('verif') || normalizedCode.contains('golden')) {
      return Icons.verified_outlined;
    }
    if (normalizedCode.contains('message') || normalizedCode.contains('chat')) {
      return Icons.chat_bubble_outline_rounded;
    }
    if (normalizedCode.contains('visitor') || normalizedCode.contains('view')) {
      return Icons.visibility_outlined;
    }
    return Icons.bolt_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileWidth = (constraints.maxWidth - 8.w) / 2;

        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: features
              .map(
                (feature) => SizedBox(
                  width: tileWidth,
                  child: _PremiumBenefitTile(
                    icon: _getFeatureIcon(feature.code),
                    title: feature.title,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _PremiumBenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PremiumBenefitTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          IconWidget(
            icon: icon,
            color: AppColors.white,
            width: 20.r,
            height: 20.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              title,
              color: AppColors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumActionButton extends StatelessWidget {
  final String title;
  final void Function() onActionPressed;

  const _PremiumActionButton({
    required this.title,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(50.r),
      child: InkWell(
        onTap: onActionPressed,
        borderRadius: BorderRadius.circular(50.r),
        child: Container(
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.12),
                blurRadius: 16.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                title,
                color: AppColors.textBlack,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 8.w),
              IconWidget(
                icon: Icons.arrow_back_rounded,
                color: AppColors.textBlack,
                width: 24.r,
                height: 24.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _contentOrFallback(String content, String fallback) =>
    content.trim().isEmpty ? fallback : content;

class _PremiumAtmosphericCircle extends StatelessWidget {
  final double dimension;
  final Color color;
  final double opacity;
  final double blurRadius;

  const _PremiumAtmosphericCircle({
    required this.dimension,
    required this.color,
    required this.opacity,
    required this.blurRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurRadius.r,
        sigmaY: blurRadius.r,
      ),
      child: Container(
        width: dimension.r,
        height: dimension.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _PremiumDashedRing extends StatelessWidget {
  const _PremiumDashedRing();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 128.r,
      child: CustomPaint(
        painter: _PremiumDashedRingPainter(),
      ),
    );
  }
}

class _PremiumDashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.r;
    final Rect ringBounds = Offset.zero & size;
    final Rect insetBounds = ringBounds.deflate(strokeWidth / 2);
    final Paint ringPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const int segmentCount = 12;
    final double segmentSweep = math.pi / segmentCount;
    final double segmentStep = (math.pi * 2) / segmentCount;

    for (int index = 0; index < segmentCount; index++) {
      canvas.drawArc(
        insetBounds,
        index * segmentStep,
        segmentSweep,
        false,
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PremiumShimmer extends StatefulWidget {
  const _PremiumShimmer();

  @override
  State<_PremiumShimmer> createState() => _PremiumShimmerState();
}

class _PremiumShimmerState extends State<_PremiumShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double travelWidth = constraints.maxWidth * 1.5;
              final double horizontalOffset =
                  (_controller.value * travelWidth) - travelWidth;

              return Transform.translate(
                offset: Offset(horizontalOffset, 0),
                child: child,
              );
            },
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Transform.rotate(
                angle: -0.18,
                child: const FractionallySizedBox(
                  widthFactor: 0.45,
                  heightFactor: 1.4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.transparent,
                          AppColors.promotionBadgeSheen,
                          AppColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
