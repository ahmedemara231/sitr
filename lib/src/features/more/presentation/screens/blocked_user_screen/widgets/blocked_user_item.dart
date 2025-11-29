import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../../core/widgets/icon_widget.dart';
import '../../../models/block_user_model.dart';

class BlockedUserItem extends StatelessWidget {
  const BlockedUserItem({
    super.key, required this.blockUserModel,
    required this.onDelete,
  });

  final BlockUserModel blockUserModel;
  final dynamic Function(dynamic) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          top: 10.h, bottom: 10.h, start: 16.w, end: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: Colors.white),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: IconWidget(
                icon: blockUserModel.avatar ?? '',
                width: 60,
                height: 60,
              )),
          15.szW,
          AppText(blockUserModel.name ?? '',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black),
          const Spacer(),
          DefaultButton(
            onTap: () async => onDelete.call(context),
            width: 83.w,
            height: 22.h,
            borderRadius: BorderRadius.circular(11),
            title: LocaleKeys.unblock,
            textColor: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.redColor,
          ),
        ],
      ),
    );
  }
}
