import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';

/// Floating message composer for the contact-us conversation.
/// The parent owns [controller]; this widget only reports user intent.
class ContactChatInputBar extends StatelessWidget {
  const ContactChatInputBar({
    super.key,
    required this.controller,
    required this.onSendPressed,
    required this.onCameraPressed,
  });

  final TextEditingController controller;
  final void Function() onSendPressed;
  final void Function() onCameraPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: LocaleKeys.writeYourMessageHere,
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGray.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    8.szW,
                    InkWell(
                      onTap: onCameraPressed,
                      customBorder: const CircleBorder(),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: AppColors.primary,
                        size: 24.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            12.szW,
            InkWell(
              onTap: onSendPressed,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: 56.h,
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: -0.785398, // -45deg
                  child: Icon(
                    Icons.send,
                    color: AppColors.primary,
                    size: 26.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
