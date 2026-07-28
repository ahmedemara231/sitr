import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
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
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onProfilePressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.06),
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              _RequestUserDetails(sender: sender),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: AppLoadingButton(
                      asyncCall: (_) => onAcceptPressed(),
                      title: LocaleKeys.accept,
                      height: 42.h,
                      enabled: request.canAccept,
                      buttonColor: request.canAccept
                          ? AppColors.primary
                          : AppColors.whiteGrey,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppLoadingButton(
                      asyncCall: (_) => onRejectPressed(),
                      title: LocaleKeys.refused,
                      height: 42.h,
                      buttonColor: AppColors.white,
                      borderColor: AppColors.error,
                      textColor: AppColors.error,
                    ),
                  ),
                ],
              ),
              if (!request.canAccept) ...[
                SizedBox(height: 10.h),
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

  const _RequestUserDetails({required this.sender});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedImage(
          url: sender.avatar.isEmpty
              ? ConstantManager.defaultAvatar
              : sender.avatar,
          width: 64.w,
          height: 64.w,
          boxShape: BoxShape.circle,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PremiumUserName(
                name: sender.displayName,
                isPremium: sender.isPromoted,
              ),
              SizedBox(height: 8.h),
              AppText(
                _details,
                fontSize: 13.sp,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp,
          color: AppColors.primary,
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
