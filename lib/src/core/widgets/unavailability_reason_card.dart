import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import 'app_text.dart';

class UnavailabilityReasonCard extends StatelessWidget {
  final ChatReason? reason;
  const UnavailabilityReasonCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.h,
        children: [
          AppText(
            LocaleKeys.unavailabilityReason,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          AppText(
            reason.getReason,
            color: AppColors.secondary,
            fontSize: 10.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
