import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../../../generated/assets.dart' show Assets;
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/icon_widget.dart';
import '../complaint_details_screen.dart';

class ComplaintsAndSuggestionsItem extends StatelessWidget {
  const ComplaintsAndSuggestionsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Go.to(const ComplaintDetailsScreen());

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
            Image.asset(
              Assets.imagesComplaint,
              height: 100,
              width: 100,
            ),
            11.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${LocaleKeys.complaintNumber}: 5214',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  11.szH,
                  Row(
                    children: [
                      const IconWidget(icon: Assets.svgCalendar),
                      5.szW,
                      const AppText(
                        '2/9/2025',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                      const Spacer(),
                      AppText(
                        LocaleKeys.inProgress,
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
