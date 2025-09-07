import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/res/config_imports.dart';
import '../app_text.dart';
import 'custom_app_buttons/loading_button.dart';

class AppLoadingButton extends StatelessWidget {
  final Future<void> Function(BuildContext context) asyncCall;
  final String title;
  const AppLoadingButton({super.key,
    required this.asyncCall,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      borderRadius: ConstantManager.buttonBorderRadiusNumber,
      height: 45.h,
      idleWidget: AppText(
        title,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      call: (BuildContext context) async => await asyncCall.call(context),
    );
  }
}
