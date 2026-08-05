import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/auth/imports.dart';
import '../../navigation/navigator.dart';
import '../app_text.dart';
import '../icon_widget.dart';

class LoginWhenVisitorSheet extends StatelessWidget {
  const LoginWhenVisitorSheet({super.key});

  void _openLogin() {
    unawaited(Go.offAll(const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4.w, 4.h, 4.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _VisitorLoginMessage(),
              SizedBox(height: 20.h),
              _VisitorLoginButton(
                title: LocaleKeys.login,
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
                fontWeight: FontWeight.bold,
                onTap: _openLogin,
              ),
              SizedBox(height: 10.h),
              _VisitorLoginButton(
                title: LocaleKeys.cancel,
                backgroundColor: AppColors.white,
                textColor: AppColors.darkGray,
                borderColor: AppColors.border,
                fontWeight: FontWeight.w500,
                onTap: Go.back,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisitorLoginMessage extends StatelessWidget {
  const _VisitorLoginMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 20.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const _VisitorLoginIllustration(),
          SizedBox(height: 18.h),
          AppText(
            LocaleKeys.visitorLoginTitle,
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          AppText(
            LocaleKeys.visitorLoginDescription,
            color: AppColors.darkGay,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            height: 1.55,
          ),
        ],
      ),
    );
  }
}

class _VisitorLoginIllustration extends StatelessWidget {
  const _VisitorLoginIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 92.r,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
          ),
          Container(
            width: 64.r,
            height: 64.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackShadow.withValues(alpha: 0.06),
                  blurRadius: 18.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: IconWidget(
              icon: Assets.svgUser,
              width: 34.r,
              height: 34.r,
            ),
          ),
          PositionedDirectional(
            end: -1.w,
            bottom: 2.h,
            child: Container(
              width: 30.r,
              height: 30.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: AppColors.white, width: 3.r),
              ),
              child: IconWidget(
                icon: Icons.lock_rounded,
                color: AppColors.white,
                width: 14.r,
                height: 14.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitorLoginButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  const _VisitorLoginButton({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.fontWeight,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: SizedBox(
          width: double.infinity,
          height: 54.h,
          child: Center(
            child: AppText(
              title,
              color: textColor,
              fontSize: 14.sp,
              fontWeight: fontWeight,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
