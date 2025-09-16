import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/lancher_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';

class ConsultantScreen extends StatelessWidget {
  const ConsultantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appBarTitle: LocaleKeys.consultants),
      body: ListView.separated(itemBuilder: (context, index) =>
          Container(
            padding: EdgeInsets.all(12.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      Assets.imagesComplaint,
                      width: 63.w,
                      height: 61.h,
                    ),
                    11.szW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            'اسم الاستشاري',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          11.szH,
                          Row(
                            children: [
                              const IconWidget(
                                icon: Assets.svgPhoneIcon,
                              ),
                              5.szW,
                              GestureDetector(
                                onTap: (){
                                  LauncherHelper.callPhone(phone: '00966554646423');
                                },
                                child: AppText(
                                  '00966554646423',
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
                const AppText(
                  'التعلم والتطور. تحمل في داخلها شغفًا للمعرفة وتقديرًا '
                      'التعلم والتطور. تحمل في داخلها شغفًا للمعرفة وتقديرًا '
                      'التعلم والتطور. تحمل في داخلها شغفًا للمعرفة وتقديرًا '
                      'التعلم والتطور. تحمل في داخلها شغفًا للمعرفة وتقديرًا '
                      'التعلم والتطور. تحمل في داخلها شغفًا للمعرفة وتقديرًا '
                  ,
                  maxLines: 4,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGay,
                )
              ],
            ),
          ), separatorBuilder: (context, index) => 10.szH, itemCount: 5).paddingAll(16.r),
    );
  }
}
