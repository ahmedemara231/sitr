import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../navigation/navigator.dart';
import '../../app_text.dart';
import '../../icon_widget.dart';

class PromotionSheetHandle extends StatelessWidget {
  const PromotionSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
      child: Container(
        width: 36.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}

class PromotionSheetHeader extends StatelessWidget {
  final bool showCloseButton;
  final PromotionSheetDataModel data;

  const PromotionSheetHeader({
    super.key,
    required this.data,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.promotionBadgeGradientStart,
            AppColors.promotionBadgeGradientMiddle,
            AppColors.promotionBadgeGradientEnd,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.h, 20.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const PromotionSheetCrownIcon(),
                      SizedBox(width: 8.w),
                      AppText(
                        _contentOrFallback(
                          data.title,
                          LocaleKeys.promotionSheetTitle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                if (showCloseButton)
                  const PromotionSheetCloseButton(onTap: Go.back),
              ],
            ),
            SizedBox(height: 6.h),
            AppText(
              _contentOrFallback(
                data.subtitle,
                LocaleKeys.promotionSheetSubtitle,
              ),
              textAlign: TextAlign.start,
              color: AppColors.white.withValues(alpha: 0.80),
              fontSize: 12.sp,
              height: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionSheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const PromotionSheetCloseButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 28.r,
          child: IconWidget(
            icon: Icons.close_rounded,
            color: AppColors.white,
            width: 16.sp,
            height: 16.sp,
          ),
        ),
      ),
    );
  }
}

class PromotionSheetCrownIcon extends StatelessWidget {
  const PromotionSheetCrownIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.18),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 18.w,
        height: 16.h,
        child: CustomPaint(
          painter: PromotionSheetCrownPainter(),
        ),
      ),
    );
  }
}

class PromotionSheetCrownPainter extends CustomPainter {
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

String _contentOrFallback(String content, String fallback) =>
    content.trim().isEmpty ? fallback : content;
