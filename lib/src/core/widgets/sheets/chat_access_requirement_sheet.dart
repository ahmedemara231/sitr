import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../navigation/navigator.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';

class ChatAccessRequirementSheet extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String description;
  final String actionTitle;
  final Future<void> Function() onActionPressed;

  const ChatAccessRequirementSheet({
    required this.illustration,
    required this.title,
    required this.description,
    required this.actionTitle,
    required this.onActionPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 20.w, 22.h),
            decoration: BoxDecoration(
              color: AppColors.whiteGreyColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                illustration,
                SizedBox(height: 18.h),
                AppText(
                  title,
                  color: AppColors.textBlack,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                AppText(
                  description,
                  color: AppColors.darkGay,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  height: 1.55,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          AppLoadingButton(
            asyncCall: (_) => onActionPressed(),
            title: actionTitle,
            height: 54.h,
            borderRadius: 50.r,
          ),
          SizedBox(height: 10.h),
          AppLoadingButton(
            asyncCall: (_) async => Go.back(),
            title: LocaleKeys.cancel,
            height: 54.h,
            borderRadius: 50.r,
            buttonColor: AppColors.white,
            borderColor: AppColors.border,
            textColor: AppColors.darkGray,
          ),
        ],
      ),
    );
  }
}
