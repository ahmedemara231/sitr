import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/res/config_imports.dart';
import '../app_text.dart';
import 'custom_app_buttons/loading_button.dart';

class AppLoadingButton extends StatelessWidget {
  final Future<void> Function(BuildContext context) asyncCall;
  final String title;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  final Color? buttonColor;
  final FontWeight? fontWeight;

  const AppLoadingButton({
    super.key,
    required this.asyncCall,
    required this.title,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.buttonColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
        title: title,
        width: width,
        height: height,
        borderRadius: borderRadius,
        fontSize: fontSize,
        textColor: textColor,
        color: buttonColor,
        fontWeight: fontWeight,
        onTap: (context) => asyncCall.call(context)
    );
  }
}
