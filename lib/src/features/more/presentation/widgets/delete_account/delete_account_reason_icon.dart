import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';

class DeleteAccountReasonIcon extends StatelessWidget {
  final IconData icon;

  const DeleteAccountReasonIcon({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .18),
        ),
      ),
      child: Icon(icon, size: 19.r, color: AppColors.primary),
    );
  }
}
