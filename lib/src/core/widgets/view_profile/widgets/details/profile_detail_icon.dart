import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../icon_widget.dart';

class ProfileDetailIcon extends StatelessWidget {
  final String icon;
  final double? size;

  const ProfileDetailIcon({
    super.key,
    required this.icon,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double iconContainerSize = size ?? 34.r;
    return Container(
      width: iconContainerSize,
      height: iconContainerSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.offWhite,
        shape: BoxShape.circle,
      ),
      child: IconWidget(
        icon: icon,
        width: 17.r,
        height: 17.r,
        color: AppColors.primary,
      ),
    );
  }
}
