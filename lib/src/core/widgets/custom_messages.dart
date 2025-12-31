import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../config/res/config_imports.dart';
import '../navigation/navigator.dart';

class MessageUtils {
  static void showTopMsg(String msg, {BuildContext? context}){
    showTopSnackBar(
      Overlay.of(context??Go.context),
      CustomSnackBar.info(
        message: msg,
      ),
    );
  }

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
