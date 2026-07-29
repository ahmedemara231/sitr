import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/premium_user_badge.dart';
import '../../data/models/message_request_model.dart';

class MessageRequestCard extends StatelessWidget {
  final MessageRequestModel request;
  final void Function() onProfilePressed;
  final Future<void> Function() onAcceptPressed;
  final Future<void> Function() onRejectPressed;

  const MessageRequestCard({
    required this.request,
    required this.onProfilePressed,
    required this.onAcceptPressed,
    required this.onRejectPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MessageRequestUserModel sender = request.sender;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onProfilePressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.06),
                blurRadius: 64.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _RequestUserDetails(
                      sender: sender,
                      canAccept: request.canAccept,
                      onAcceptPressed: onAcceptPressed,
                      onRejectPressed: onRejectPressed,
                    ),
                  ),
                  16.szW,
                  CachedImage(
                    url: sender.avatar.isEmpty
                        ? ConstantManager.defaultAvatar
                        : sender.avatar,
                    width: 64.w,
                    height: 64.w,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ],
              ),
              if (!request.canAccept) ...[
                10.szH,
                AppText(
                  LocaleKeys.messageRequestAcceptBlocked,
                  fontSize: 11.sp,
                  color: AppColors.error,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestUserDetails extends StatelessWidget {
  final MessageRequestUserModel sender;
  final bool canAccept;
  final Future<void> Function() onAcceptPressed;
  final Future<void> Function() onRejectPressed;

  const _RequestUserDetails({
    required this.sender,
    required this.canAccept,
    required this.onAcceptPressed,
    required this.onRejectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumUserName(
          name: sender.displayName,
          isPremium: sender.isPromoted,
          fontSize: 14.sp,
        ),
        4.szH,
        AppText(
          _details,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          fontSize: 10.sp,
          color: AppColors.darkGay,
        ),
        12.szH,
        Row(
          children: [
            AppLoadingButton(
              asyncCall: (_) => onAcceptPressed(),
              title: LocaleKeys.acceptConnectionRequest,
              width: 72.w,
              height: 32.h,
              borderRadius: 50.r,
              enabled: canAccept,
              buttonColor: canAccept ? AppColors.primary : AppColors.whiteGrey,
              textColor:
                  canAccept ? AppColors.white : AppColors.unSelectedLabelColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            8.szW,
            AppLoadingButton(
              asyncCall: (_) => onRejectPressed(),
              title: LocaleKeys.ignoreConnectionRequest,
              width: 72.w,
              height: 32.h,
              borderRadius: 50.r,
              buttonColor: AppColors.whiteGrey,
              textColor: AppColors.unSelectedLabelColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  String get _details {
    final List<String> details = [
      if (sender.city.isNotEmpty) sender.city,
      if (sender.age > 0) '${sender.age} ${LocaleKeys.years}',
    ];
    return details.join(' • ');
  }
}
