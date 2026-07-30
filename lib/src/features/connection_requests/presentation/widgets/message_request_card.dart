import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/premium_user_badge.dart';
import '../../../../core/widgets/request_actions.dart';
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

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onProfilePressed,
              borderRadius: BorderRadius.circular(8.r),
              child: _RequestUserSummary(sender: sender),
            ),
          ),
          16.szH,
          RequestActions(
            canAccept: request.canAccept,
            onAcceptPressed: onAcceptPressed,
            onRejectPressed: onRejectPressed,
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
    );
  }
}

class _RequestUserSummary extends StatelessWidget {
  final MessageRequestUserModel sender;

  const _RequestUserSummary({required this.sender});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedImage(
          url: sender.avatar.isEmpty
              ? ConstantManager.defaultAvatar
              : sender.avatar,
          width: 64.w,
          height: 64.w,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(8.r),
        ),
        16.szW,
        Expanded(
          child: SizedBox(
            height: 64.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PremiumUserName(
                    name: sender.displayName, isPremium: sender.isPromoted),
                4.szH,
                _RequestMetadata(
                  age: sender.age,
                  city: sender.city,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestMetadata extends StatelessWidget {
  final int age;
  final String city;

  const _RequestMetadata({
    required this.age,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAge = age > 0;
    final bool hasCity = city.isNotEmpty;

    return Row(
      children: [
        if (hasAge)
          AppText(
            '$age ${LocaleKeys.connectionRequestYearsOld}',
            color: AppColors.darkGay,
            fontSize: 10.sp,
            height: 1.4,
          ),
        if (hasAge && hasCity) ...[
          8.szW,
          Container(
            width: 4.r,
            height: 4.r,
            decoration: const BoxDecoration(
              color: AppColors.border,
              shape: BoxShape.circle,
            ),
          ),
          8.szW,
        ],
        if (hasCity)
          Flexible(
            child: AppText(
              city,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColors.darkGay,
              fontSize: 10.sp,
              height: 1.4,
            ),
          ),
      ],
    );
  }
}
