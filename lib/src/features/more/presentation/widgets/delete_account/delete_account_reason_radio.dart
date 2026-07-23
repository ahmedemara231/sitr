import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';

class DeleteAccountReasonRadio extends StatelessWidget {
  final bool selected;

  const DeleteAccountReasonRadio({
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? AppColors.primary.withValues(alpha: .08)
            : AppColors.transparent,
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.deleteAccountReasonRadioBorder,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: selected ? 10.r : 0,
          height: selected ? 10.r : 0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
