import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../app_text.dart';
import '../../models/profile_detail_item_model.dart';
import 'profile_detail_icon.dart';

class ProfileCompactDetailItem extends StatelessWidget {
  final ProfileDetailItemModel item;

  const ProfileCompactDetailItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = item.value != null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Row(
        children: [
          ProfileDetailIcon(icon: item.icon, size: 32.r),
          9.szW,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.label,
                  maxLines: 2,
                  fontSize: 11.sp,
                  color: AppColors.darkGay,
                ),
                3.szH,
                AppText(
                  item.value ?? LocaleKeys.notSetYet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: hasValue
                      ? AppColors.textBlack
                      : AppColors.darkGay.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
