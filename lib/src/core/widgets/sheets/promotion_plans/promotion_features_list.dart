import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../app_text.dart';
import '../../icon_widget.dart';

class PromotionFeaturesList extends StatelessWidget {
  final String title;
  final List<PromotionFeatureModel> features;

  const PromotionFeaturesList({
    required this.title,
    required this.features,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          '$title:',
          textAlign: TextAlign.start,
          color: AppColors.mediumGray,
          fontSize: 12.sp,
        ),
        SizedBox(height: 8.h),
        ...features.map(
          (PromotionFeatureModel feature) => Padding(
            padding: EdgeInsets.only(bottom: 7.h),
            child: Row(
              children: [
                const PromotionCheckIcon(),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppText(
                    feature.title,
                    textAlign: TextAlign.start,
                    color: AppColors.darkGray,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PromotionCheckIcon extends StatelessWidget {
  const PromotionCheckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14.r,
      height: 14.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
      child: IconWidget(
        icon: Icons.check_rounded,
        color: AppColors.primary,
        width: 11.sp,
        height: 11.sp,
      ),
    );
  }
}
