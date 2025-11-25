import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/default_bottom_sheet.dart';

class ChatSheetManager {
  static bool isOpened = false;

  static Future<void> show({required Widget child}) async {
    if (isOpened) {
      Go.back();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await _manageSheet(child);
  }

  static Future<void> _manageSheet(Widget child) async {
    isOpened = true;
    await showDefaultBottomSheet(enableDrag: false, child: child);
    isOpened = false;
  }
}

// tips
// accept - reject
// push offer
// other