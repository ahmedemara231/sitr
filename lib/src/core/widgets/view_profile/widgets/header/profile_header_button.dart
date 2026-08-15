import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../icon_widget.dart';

class ProfileHeaderButton extends StatelessWidget {
  final String semanticLabel;
  final dynamic icon;
  final void Function() onPressed;

  const ProfileHeaderButton({
    super.key,
    required this.semanticLabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onPressed,
        child: Container(
          width: 40.r,
          height: 40.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: IconWidget(
            icon: icon,
            width: 18.r,
            height: 18.r,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}
