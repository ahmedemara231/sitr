import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../../shared/models/user_models/individual/individual_user_model.dart';
import '../../../app_text.dart';
import '../../../icon_widget.dart';
import '../../../image_widgets/cached_image.dart';

class ParentProfileLink extends StatelessWidget {
  final ChildParentInfo parentInfo;
  final void Function() onPressed;

  const ParentProfileLink({
    super.key,
    required this.parentInfo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(6.w, 5.h, 12.w, 5.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedImage(
              url: parentInfo.avatar,
              width: 28.r,
              height: 28.r,
              boxShape: BoxShape.circle,
              placeHolder: IconWidget(
                icon: Assets.assets.svg.parentIcon.path,
                color: AppColors.primary,
              ),
              bgColor: AppColors.offWhite,
            ),
            8.szW,
            Flexible(
              child: AppText(
                parentInfo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
