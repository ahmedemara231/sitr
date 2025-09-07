import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/res/config_imports.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/padding_extension.dart';
import '../../navigation/navigator.dart';
import '../app_text.dart';

class AppScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;

  const AppScaffold({super.key,
    required this.appBarTitle,
    required this.body
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size(context.width, 60.h),
          child: AppBar(
            backgroundColor: AppColors.whiteGreyColor,
            centerTitle: true,
            title: AppText(appBarTitle, fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black,),
            leading: const AppBackButton(),
          )
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r)
          ),
          child: body.defaultScreenPadding(),
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: FittedBox(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
          ),
          child: IconButton(
              onPressed: () => Go.back(),
              icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black, size: 14)
          ),
        ).paddingAll(12.r),
      ),
    );
  }
}
