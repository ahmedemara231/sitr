import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/sized_box_helper.dart';
import 'buttons/app_loading_button.dart';

class RequestActions extends StatelessWidget {
  final bool canAccept;
  final Future<void> Function() onAcceptPressed;
  final Future<void> Function() onRejectPressed;

  const RequestActions({
    required this.canAccept,
    required this.onAcceptPressed,
    required this.onRejectPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppLoadingButton(
            asyncCall: (_) => onAcceptPressed(),
            title: LocaleKeys.acceptConnectionRequest,
            height: 40.h,
            borderRadius: 50.r,
            enabled: canAccept,
            buttonColor: canAccept
                ? AppColors.connectionRequestAccept
                : AppColors.whiteGrey,
            textColor:
                canAccept ? AppColors.white : AppColors.unSelectedLabelColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        12.szW,
        Expanded(
          child: AppLoadingButton(
            asyncCall: (_) => onRejectPressed(),
            title: LocaleKeys.rejectConnectionRequest,
            height: 40.h,
            borderRadius: 50.r,
            buttonColor: AppColors.error,
            borderColor: AppColors.border,
            textColor: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
