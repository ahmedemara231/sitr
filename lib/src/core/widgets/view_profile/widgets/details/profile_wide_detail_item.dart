import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../app_text.dart';
import '../../models/profile_detail_item_model.dart';
import 'profile_detail_icon.dart';

class ProfileWideDetailItem extends StatelessWidget {
  final ProfileDetailItemModel item;

  const ProfileWideDetailItem({
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
          ProfileDetailIcon(icon: item.icon),
          12.szW,
          Expanded(
            child: AppText(
              item.label,
              fontSize: 12.sp,
              color: AppColors.darkGay,
            ),
          ),
          12.szW,
          Flexible(
            child: AppText(
              item.value ?? LocaleKeys.notSetYet,
              textAlign: TextAlign.end,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: hasValue
                  ? AppColors.textBlack
                  : AppColors.darkGay.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
