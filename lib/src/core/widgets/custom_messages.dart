import 'package:flutter/material.dart';
import '../../config/res/config_imports.dart';
import '../navigation/navigator.dart';

class MessageUtils {
  static void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    BuildContext? context,
  }) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: ConstantManager.snackbarDuration),
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.red,
          fontSize: FontSize.s14,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.white,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context ?? Go.context)
        .showSnackBar(snackBar);
  }
}
