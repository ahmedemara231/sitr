import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/default_bottom_sheet.dart';

class ChatSheetManager {
  static bool isOpened = false;

  static Future<dynamic> show({required Widget child, FutureOr<void> Function()? onDismiss}) async {
    if (isOpened) {
      Go.back();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return await _manageSheet(child: child, onDismiss: onDismiss);
  }

  static Future<dynamic> _manageSheet({required Widget child, FutureOr<void> Function()? onDismiss}) async {
    isOpened = true;
    final result = await showDefaultBottomSheet(enableDrag: true, child: child);
    onDismiss?.call();
    isOpened = false;
    return result;
  }
}