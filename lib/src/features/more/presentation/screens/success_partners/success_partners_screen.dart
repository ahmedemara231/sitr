import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';

class SuccessPartnersScreen extends StatelessWidget {
  const SuccessPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.whiteGreyColorProMax,
      appBar: customAppBar(appBarTitle: LocaleKeys.successPartners),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 163 / 132,
        ),
        itemCount: 10, // total items
        itemBuilder: (context, index) {
          return Container(
            height: 132.h,
            width: 163.w,
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: IconWidget(
              icon: Assets.imagesSuccessPartener,
              height: 98.h,
              width: 142.w,
            ),
          );
        },
      ).paddingAll(16.r),
    );
  }
}
