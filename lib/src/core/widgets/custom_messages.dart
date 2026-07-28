import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../shared/base_state.dart';
import 'app_text.dart';

class Messages {
  static ToastificationItem showToast({
    required String msg,
    BaseStatus status = BaseStatus.success,
    String? title,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    final _ToastDesign design = _ToastDesign.fromStatus(status);

    return Toastification().show(
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 220),
      autoCloseDuration: autoCloseDuration,
      type: design.type,
      style: ToastificationStyle.flat,
      title: AppText(
        title ?? design.title,
        color: _ToastPalette.navy,
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      description: AppText(
        msg,
        color: _ToastPalette.gray,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        height: 1.25,
      ),
      icon: _ToastIcon(design: design),
      primaryColor: design.accentColor,
      backgroundColor: design.backgroundColor,
      foregroundColor: design.accentColor,
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 10.w, 12.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: design.borderColor),
      boxShadow: const [
        BoxShadow(
          color: _ToastPalette.shadowBlack04,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
      progressBarTheme: ProgressIndicatorThemeData(
        color: design.accentColor,
        linearMinHeight: 2.r,
        linearTrackColor: design.borderColor,
      ),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) => IconButton(
          onPressed: onClose,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(32.r, 32.r)),
          icon: Icon(
            Icons.close_rounded,
            color: _ToastPalette.gray,
            size: 18.r,
          ),
        ),
      ),
      dragToClose: true,
      showIcon: true,
      dismissDirection: DismissDirection.horizontal,
      pauseOnHover: true,
      showProgressBar: true,
    );
  }
}

class _ToastIcon extends StatelessWidget {
  final _ToastDesign design;

  const _ToastIcon({required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: design.iconBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(design.icon, color: design.accentColor, size: 18.r),
    );
  }
}

class _ToastDesign {
  final String title;
  final Color accentColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final ToastificationType type;

  const _ToastDesign({
    required this.title,
    required this.accentColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.type,
  });

  factory _ToastDesign.fromStatus(BaseStatus status) {
    switch (status) {
      case BaseStatus.success:
        return _ToastDesign(
          title: LocaleKeys.successDone,
          accentColor: _ToastPalette.green,
          backgroundColor: _ToastPalette.greenPale,
          borderColor: _ToastPalette.greenAlpha19,
          iconBackgroundColor: _ToastPalette.greenAlpha09,
          icon: Icons.check_rounded,
          type: const ToastificationType.custom(
            'satr_success',
            _ToastPalette.green,
            Icons.check_rounded,
          ),
        );
      case BaseStatus.error:
        return _ToastDesign(
          title: LocaleKeys.operationFaild,
          accentColor: _ToastPalette.rose,
          backgroundColor: _ToastPalette.redPale,
          borderColor: _ToastPalette.roseAlpha19,
          iconBackgroundColor: _ToastPalette.roseAlpha07,
          icon: Icons.close_rounded,
          type: const ToastificationType.custom(
            'satr_error',
            _ToastPalette.rose,
            Icons.close_rounded,
          ),
        );
      case BaseStatus.initial:
      case BaseStatus.loading:
      case BaseStatus.loadingMore:
        return const _ToastDesign(
          title: ConstantManager.projectName,
          accentColor: _ToastPalette.blue,
          backgroundColor: _ToastPalette.bluePale,
          borderColor: _ToastPalette.grayPale,
          iconBackgroundColor: _ToastPalette.grayOffWhite,
          icon: Icons.info_outline_rounded,
          type: ToastificationType.custom(
            'satr_info',
            _ToastPalette.blue,
            Icons.info_outline_rounded,
          ),
        );
    }
  }
}

abstract class _ToastPalette {
  static const Color shadowBlack04 = Color(0x0A000000);
  static const Color navy = Color(0xFF111827);
  static const Color gray = Color(0xFF6B7280);
  static const Color grayPale = Color(0xFFE5E7EB);
  static const Color grayOffWhite = Color(0xFFF9FAFB);
  static const Color green = Color(0xFF16A34A);
  static const Color greenAlpha09 = Color(0x1816A34A);
  static const Color greenAlpha19 = Color(0x3016A34A);
  static const Color greenPale = Color(0xFFEAFBF1);
  static const Color blue = Color(0xFF2563EB);
  static const Color bluePale = Color(0xFFEEF5FF);
  static const Color redPale = Color(0xFFFFF1F1);
  static const Color rose = Color(0xFFE11D48);
  static const Color roseAlpha07 = Color(0x12E11D48);
  static const Color roseAlpha19 = Color(0x30E11D48);
}

enum MsgState { success, error, info }

/// Compatibility layer for existing call sites while they migrate to
/// [Messages.showToast].
class MessageUtils {
  static ToastificationItem showTopMsg(
    String msg, {
    MsgState state = MsgState.error,
  }) {
    return Messages.showToast(
      msg: msg,
      status: switch (state) {
        MsgState.success => BaseStatus.success,
        MsgState.error => BaseStatus.error,
        MsgState.info => BaseStatus.initial,
      },
    );
  }

  static ToastificationItem showSnackBar(String message) {
    return Messages.showToast(msg: message);
  }
}
