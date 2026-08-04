import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../core/widgets/icon_widget.dart';

class PackageActionFooter extends StatelessWidget {
  final String title;
  final bool isSecondary;
  final Color accentColor;
  final VoidCallback onPressed;

  const PackageActionFooter({
    required this.title,
    required this.isSecondary,
    required this.accentColor,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor = isSecondary ? accentColor : AppColors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      color: AppColors.white,
      child: DefaultButton(
        width: double.infinity,
        height: 50.h,
        borderRadius: BorderRadius.circular(50.r),
        color: isSecondary ? AppColors.white : accentColor,
        borderColor: accentColor,
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
      ),
    );
  }
}
