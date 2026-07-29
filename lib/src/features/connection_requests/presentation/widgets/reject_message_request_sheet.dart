import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../chats/data/chat_sheet_manager.dart';

Future<void> showRejectMessageRequestSheet({
  required String senderName,
  required Future<bool> Function() onRejectConfirmed,
}) async {
  await ChatSheetManager.show(
    withPadding: false,
    child: RejectMessageRequestSheet(
      senderName: senderName,
      onRejectConfirmed: onRejectConfirmed,
    ),
  );
}

class RejectMessageRequestSheet extends StatelessWidget {
  final String senderName;
  final Future<bool> Function() onRejectConfirmed;

  const RejectMessageRequestSheet({
    super.key,
    required this.senderName,
    required this.onRejectConfirmed,
  });

  Future<void> _confirmRejection() async {
    await onRejectConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final String questionMark =
        Directionality.of(context) == TextDirection.rtl ? '؟' : '?';

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 14.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.errorContainer,
            ),
            alignment: Alignment.center,
            child: IconWidget(
              icon: Icons.warning_amber_rounded,
              color: AppColors.error,
              width: 32.r,
              height: 32.r,
            ),
          ),
          16.szH,
          AppText(
            LocaleKeys.confirmConnectionRequestRejection,
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          8.szH,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4.w,
              children: [
                AppText(
                  LocaleKeys.confirmRejectConnectionRequestMessage,
                  color: AppColors.darkGay,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
                AppText(
                  '$senderName$questionMark',
                  color: AppColors.textBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
              ],
            ),
          ),
          32.szH,
          AppLoadingButton(
            asyncCall: (_) => _confirmRejection(),
            title: LocaleKeys.confirmRejectConnectionRequestAction,
            height: 54.h,
            borderRadius: 50.r,
            buttonColor: AppColors.error,
            fontSize: 14.sp,
          ),
          12.szH,
          Material(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(50.r),
            child: InkWell(
              onTap: Go.back,
              borderRadius: BorderRadius.circular(50.r),
              child: Ink(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: AppText(
                    LocaleKeys.keepConnectionRequest,
                    color: AppColors.textBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
