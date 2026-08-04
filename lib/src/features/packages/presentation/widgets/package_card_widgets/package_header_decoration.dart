import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';

class PackageHeaderDecoration extends StatelessWidget {
  final double size;

  const PackageHeaderDecoration({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}
