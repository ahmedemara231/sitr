import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';

class DeleteAccountWarningIcon extends StatelessWidget {
  final Animation<double> animation;

  const DeleteAccountWarningIcon({
    required this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        width: 72.r,
        height: 72.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(
            alpha: .08 + animation.value * .06,
          ),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: .28),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: .12 + animation.value * .16,
              ),
              blurRadius: 16 + animation.value * 16,
              spreadRadius: animation.value * 2,
            ),
          ],
        ),
        child: Icon(
          Icons.warning_amber_rounded,
          size: 32.r,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
