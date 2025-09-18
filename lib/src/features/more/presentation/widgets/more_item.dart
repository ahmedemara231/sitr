import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../screens/more_screen.dart';
import '../widgets/custom_icon_inside_container.dart';

class MoreItem extends StatelessWidget {
  const MoreItem({
    super.key,required this.moreItemModel,
  });


final MorItemModel moreItemModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:moreItemModel.onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Row(
            children: [
               CustomIconInsideContainer(
                icon:moreItemModel. icon,
                backgroundColor: AppColors.offWhite,
              ),
              10.szW,
              AppText(
                moreItemModel.label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const Spacer(),
              const IconWidget(icon: Assets.svgArrowLeftIcon)
            ],
          )),
    );
  }
}
