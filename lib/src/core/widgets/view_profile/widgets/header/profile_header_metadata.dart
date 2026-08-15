import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../app_text.dart';
import '../../../icon_widget.dart';

class ProfileHeaderMetadata extends StatelessWidget {
  final String icon;
  final String value;

  const ProfileHeaderMetadata({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidget(
          icon: icon,
          height: 14.r,
          width: 14.r,
          color: AppColors.primary,
        ),
        5.szW,
        AppText(
          value,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGay,
        ),
      ],
    );
  }
}
