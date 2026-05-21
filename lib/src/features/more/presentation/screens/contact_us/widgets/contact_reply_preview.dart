import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../models/contact_message.dart';

/// WhatsApp / Messenger-style "Replying to …" preview shown above the
/// composer. Animates in/out with [AnimatedSize] so the input bar slides
/// up smoothly when a target is set or cleared.
class ContactReplyPreview extends StatelessWidget {
  const ContactReplyPreview({
    super.key,
    required this.target,
    required this.onCancel,
  });

  final ContactMessage? target;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.bottomCenter,
      child: target == null
          ? const SizedBox(width: double.infinity)
          : _PreviewBody(message: target!, onCancel: onCancel),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.message, required this.onCancel});

  final ContactMessage message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            12.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '${LocaleKeys.replyingTo} ${message.authorName}',
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.szH,
                  AppText(
                    message.message,
                    color: AppColors.textBlack.withValues(alpha: 0.7),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            8.szW,
            InkWell(
              onTap: onCancel,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.close,
                  size: 18.r,
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
