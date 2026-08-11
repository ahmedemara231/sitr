import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/helpers/lancher_helper.dart' show LauncherHelper;
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/icon_widget.dart';
import '../../../models/consultant_model.dart';

class ConsultantItem extends StatelessWidget {
  const ConsultantItem({
    super.key, required this.consultantModel,
  });
final ConsultantModel consultantModel ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconWidget(icon:  consultantModel.image??'',
                width: 63.w,
                height: 61.h,
              ),
              11.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      AppText(
                       consultantModel.name??'',
                       overflow: TextOverflow.ellipsis,
                       maxLines: 2,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    11.szH,
                    Row(
                      children: [
                        IconWidget(
                          icon: Assets.assets.svg.phoneIcon.path,
                        ),
                        5.szW,
                        GestureDetector(
                          onTap: () {
                            LauncherHelper.callPhone(
                                phone: consultantModel.fullPhone??'');
                          },
                          child: AppText(
                            consultantModel.fullPhone??'',
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
           AppText(consultantModel.description??'',
            maxLines: 4,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.darkGay,
          )
        ],
      ),
    );
  }
}
