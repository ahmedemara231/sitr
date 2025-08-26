import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/res/config_imports.dart';
import '../loading_button.dart';

class AppLoadingButton extends StatelessWidget {
  final Future<void> Function() asyncCall;
  final String title;
  const AppLoadingButton({super.key,
    required this.asyncCall,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      asyncCall: asyncCall,
      title: title,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      borderRadius: ConstantManager.buttonBorderRadiusNumber,
      height: 50.h,
    );
  }
}
