import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/widgets/app_text.dart';

class ConnectionRequestsHeader extends StatelessWidget {
  final void Function() onBackPressed;

  const ConnectionRequestsHeader({
    required this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppText(
            LocaleKeys.connectionRequests,
            color: AppColors.primary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          // PositionedDirectional(
          //   start: 8.w,
          //   child: IconButton(
          //     onPressed: onBackPressed,
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: AppColors.primary,
          //       size: 28.sp,
          //     ),
          //   ),
          // ),
          // PositionedDirectional(
          //   end: 16.w,
          //   child: IconWidget(
          //     icon: Assets.assets.svg.appLogo.path,
          //     width: 50.w,
          //     height: 20.h,
          //   ),
          // ),
        ],
      ),
    );
  }
}
