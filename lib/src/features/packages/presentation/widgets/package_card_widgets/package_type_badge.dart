import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/icon_widget.dart';

class PackageTypeBadge extends StatelessWidget {
  final String title;
  final IconData icon;

  const PackageTypeBadge({
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: 190.w),
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
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
              icon: icon,
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
