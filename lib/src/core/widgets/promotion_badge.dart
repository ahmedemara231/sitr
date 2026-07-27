import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import 'sheets/promotion_plans_sheet.dart';

class PromotionBadge extends StatelessWidget {
  static const double height = 50;

  const PromotionBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(28.r),
        child: InkWell(
          onTap: () => showPromotionPlansSheet(context),
          borderRadius: BorderRadius.circular(28.r),
          child: Container(
            height: height.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.promotionBadgeShadow.withValues(alpha: 0.45),
                  blurRadius: 20.r,
                  offset: Offset(0, 4.h),
                ),
                BoxShadow(
                  color: AppColors.promotionBadgeGlow.withValues(alpha: 0.30),
                  blurRadius: 6.r,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0, 0.55, 1],
                    colors: [
                      AppColors.promotionBadgeGradientStart,
                      AppColors.promotionBadgeGradientMiddle,
                      AppColors.promotionBadgeGradientEnd,
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          stops: [0.30, 0.50, 0.70],
                          colors: [
                            AppColors.transparent,
                            AppColors.promotionBadgeSheen,
                            AppColors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const _PromotionCrownIcon(),
                                SizedBox(width: 8.w),
                                const Expanded(
                                  child: _PromotionTextBlock(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const _PromotionActionPill(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PromotionCrownIcon extends StatelessWidget {
  const _PromotionCrownIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.r,
      width: 28.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.15),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 16.w,
        height: 14.h,
        child: CustomPaint(
          painter: _CrownPainter(),
        ),
      ),
    );
  }
}

class _PromotionTextBlock extends StatelessWidget {
  const _PromotionTextBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.promotionBadgeTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.white,
            fontFamily: ConstantManager.fontFamily,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        Text(
          LocaleKeys.promotionBadgeSubtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.promotionBadgeSubtitle,
            fontFamily: ConstantManager.fontFamily,
            fontSize: 11.sp,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _PromotionActionPill extends StatelessWidget {
  const _PromotionActionPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.promotionBadgeAction,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: ConstantManager.fontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.chevron_left_rounded,
            color: AppColors.white,
            size: 14.sp,
          ),
        ],
      ),
    );
  }
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 20);

    final Paint strokePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path crownPath = Path()
      ..moveTo(2, 18)
      ..lineTo(22, 18)
      ..moveTo(3, 16)
      ..relativeLineTo(3, -8)
      ..relativeLineTo(6, 4)
      ..relativeLineTo(4, -8)
      ..relativeLineTo(4, 8)
      ..relativeLineTo(3, 8);

    canvas.drawPath(crownPath, strokePaint);

    final Paint dotPaint = Paint()
      ..color = AppColors.promotionBadgeGlow
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(const Offset(3, 8), 2, dotPaint)
      ..drawCircle(const Offset(12, 4), 2, dotPaint)
      ..drawCircle(const Offset(21, 8), 2, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
