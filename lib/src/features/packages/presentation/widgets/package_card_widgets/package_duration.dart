import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/icon_widget.dart';

class PackageDuration extends StatelessWidget {
  final int duration;

  const PackageDuration({required this.duration, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconWidget(
            icon: Icons.calendar_month_outlined,
            color: AppColors.white,
            width: 16.r,
            height: 16.r,
          ),
          6.szW,
          AppText(
            '$duration ${LocaleKeys.day}',
            color: AppColors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
