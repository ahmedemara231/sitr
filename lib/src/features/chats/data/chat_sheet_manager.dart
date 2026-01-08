import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/default_bottom_sheet.dart';

class ChatSheetManager {
  static bool isOpened = false;

  static Future<dynamic> show({required Widget child}) async {
    if (isOpened) {
      Go.back();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return await _manageSheet(child);
  }

  static Future<dynamic> _manageSheet(Widget child) async {
    isOpened = true;
    final result = await
    showDefaultBottomSheet(enableDrag: true, child: child);
    isOpened = false;
    return result;
  }
}