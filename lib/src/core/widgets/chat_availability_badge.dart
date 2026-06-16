import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import 'app_text.dart';

/// A pill-shaped badge that shows whether a user is available to chat.
///
/// Use [ChatAvailabilityBadge.available] / [ChatAvailabilityBadge.notAvailable]
/// or pass [isAvailable] directly (e.g. `user.canChat?.canChat ?? false`).
class ChatAvailabilityBadge extends StatelessWidget {
  final bool isAvailable;

  const ChatAvailabilityBadge({super.key, required this.isAvailable});

  const ChatAvailabilityBadge.available({super.key}) : isAvailable = true;

  const ChatAvailabilityBadge.notAvailable({super.key}) : isAvailable = false;

  // Available palette
  static const Color _availableBg = Color(0xFFDFF6E5);
  static const Color _availableDot = Color(0xFF34C759);
  static const Color _availableText = AppColors.main;

  // Not available palette
  static const Color _notAvailableBg = Color(0xFFFDE8E8);
  static const Color _notAvailableDot = AppColors.redColor;
  static const Color _notAvailableText = AppColors.redColor;

  Color get _backgroundColor => isAvailable ? _availableBg : _notAvailableBg;
  Color get _dotColor => isAvailable ? _availableDot : _notAvailableDot;
  Color get _textColor => isAvailable ? _availableText : _notAvailableText;
  String get _label =>
      isAvailable ? LocaleKeys.availableToChat : LocaleKeys.notAvailableToChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        children: [
          Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              color: _dotColor,
              shape: BoxShape.circle,
            ),
          ),
          AppText(
            _label,
            color: _textColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
