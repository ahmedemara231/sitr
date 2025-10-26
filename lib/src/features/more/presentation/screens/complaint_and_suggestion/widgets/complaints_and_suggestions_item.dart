import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../generated/assets.dart' show Assets;
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/icon_widget.dart';
import '../../../../../../core/widgets/svg_pic.dart';
import '../../../models/complaint_model.dart';
import '../complaint_details_screen.dart';

class ComplaintsAndSuggestionsItem extends StatelessWidget {
  const ComplaintsAndSuggestionsItem({
    super.key, required this.complaintModel,
  });
final ComplaintModel complaintModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Go.to( ComplaintDetailsScreen(complaintId: complaintModel.id??0,));
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.whiteGreyColor,
                  ),
                ),
                SizedBox.square(
                    dimension: 40.sp,
                    child: const SvgPic(assetName: Assets.svgAppLogo)),
              ],
            ),
            11.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${LocaleKeys.complaintNumber}: ${complaintModel.number??''}',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  11.szH,
                  Row(
                    children: [
                      const SvgPic(assetName: Assets.svgCalendar),
                      5.szW,
                       AppText(
                        complaintModel.createdAt??'',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                      const Spacer(),
                      AppText(
                        complaintModel.status?.title??'',
                        color: AppColors.mediumGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
