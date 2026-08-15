import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/padding_extension.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../app_text.dart';
import '../../models/profile_section_model.dart';
import 'profile_detail_row.dart';

class ProfileDetailSection extends StatelessWidget {
  final ProfileSectionModel section;

  const ProfileDetailSection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          section.title,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGay,
        ).paddingSymmetric(horizontal: 4.w),
        8.szH,
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.035),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Column(
            children: List<Widget>.generate(
              section.rows.length,
              (int index) => Column(
                children: [
                  ProfileDetailRow(items: section.rows[index]),
                  if (index != section.rows.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
