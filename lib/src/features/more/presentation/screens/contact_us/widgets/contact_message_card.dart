import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../models/contact_message.dart';

/// A single bubble in the contact-us conversation thread.
/// The parent owns layout (width / indent); this widget only renders content.
class ContactMessageCard extends StatelessWidget {
  const ContactMessageCard({
    super.key,
    required this.message,
    required this.avatarSize,
    required this.onReplyTap,
    this.badgeLabel,
    this.isSelected = false,
  });

  final ContactMessage message;
  final double avatarSize;
  final String? badgeLabel;
  final void Function() onReplyTap;
  final bool isSelected;

  bool get _isSupport => message.isSupport;

  @override
  Widget build(BuildContext context) {
    final Color accent = _isSupport ? AppColors.primary : AppColors.textBlack;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: _isSupport
            ? AppColors.thirdColor.withValues(alpha: 0.7)
            : AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: isSelected ? 1.5 : 1,
          color: isSelected
              ? AppColors.primary
              : _isSupport
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.white.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            message: message,
            size: avatarSize,
            badgeLabel: badgeLabel,
          ),
          16.szW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        message.authorName,
                        color: accent,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: AppText(
                        message.time,
                        color: accent.withValues(alpha: 0.5),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                6.szH,
                if (message.highlighted)
                  _HighlightedBubble(text: message.message)
                else
                  ExpandableText(
                    message.message,
                    expandText: LocaleKeys.showMore,
                    collapseText: LocaleKeys.showLess,
                    maxLines: 3,
                    animation: true,
                    linkColor: AppColors.primary,
                    linkStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    style: TextStyle(
                      color: AppColors.textBlack.withValues(alpha: 0.8),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                if (_isSupport) ...[
                  12.szH,
                  Divider(
                    height: 1,
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                  12.szH,
                  _ReplyButton(isSupport: true, onTap: onReplyTap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.message,
    required this.size,
    this.badgeLabel,
  });

  final ContactMessage message;
  final double size;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final double dimension = size.r;
    final bool isSupport = message.isSupport;

    final Widget avatar = isSupport
        ? Container(
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: dimension * 0.5,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: Center(
              child: CachedImage(
                url: UserModel.currentUser?.avatar ?? '',
                width: dimension,
                height: dimension,
                boxShape: BoxShape.circle,
                placeHolder: Icon(
                  Icons.person,
                  color: AppColors.darkGray,
                  size: dimension * 0.5,
                ),
              ),
            ),
          );

    if (badgeLabel == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        PositionedDirectional(
          bottom: -4,
          end: -4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isSupport
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.white),
            ),
            child: AppText(
              badgeLabel!,
              color: isSupport ? AppColors.white : AppColors.primary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _HighlightedBubble extends StatelessWidget {
  const _HighlightedBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.offWhite.withValues(alpha: 0.4),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(4.r),
          bottomStart: Radius.circular(4.r),
          topEnd: Radius.circular(10.r),
          bottomEnd: Radius.circular(10.r),
        ),
        border: BorderDirectional(
          start: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 4,
          ),
        ),
      ),
      child: AppText(
        text,
        color: AppColors.textBlack,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ReplyButton extends StatelessWidget {
  const _ReplyButton({required this.isSupport, required this.onTap});

  final bool isSupport;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isSupport
        ? AppColors.primary.withValues(alpha: 0.7)
        : AppColors.darkGray;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: AppText.withIcon(
          icon: Icon(Icons.reply, size: 18.r, color: color),
          text: LocaleKeys.replyAction,
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
