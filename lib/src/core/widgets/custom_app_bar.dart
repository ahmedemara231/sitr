import 'package:dropinity/helpers/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/more/presentation/screens/contact_us/contact_us_screen.dart';
import '../navigation/navigator.dart';
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
        actions: [
          TextButton(
              onPressed: () => Go.off(const ContactUsScreen()),
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r)
                  ),
                  child: AppText(LocaleKeys.startNewConversation, color: Colors.white).paddingAll(7.r)
              )
          )
        ],
      )
  );
}
