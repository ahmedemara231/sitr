import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/res/config_imports.dart';
import 'app_text.dart';
import 'scaffolds/app_scaffold.dart';

PreferredSize customAppBar({required String appBarTitle}) {
  return PreferredSize(
      preferredSize: Size(double.infinity, 60.h),
      child: AppBar(
        backgroundColor: AppColors.whiteGreyColor,
        centerTitle: true,
        title: AppText(appBarTitle, fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black,),
        leading: const AppBackButton(),
      )
  );
}
