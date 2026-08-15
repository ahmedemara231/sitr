import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../../shared/models/user_models/individual/individual_user_model.dart';
import '../../../app_text.dart';
import '../../../chat_availability_badge.dart';
import '../../../premium_user_badge.dart';
import '../../../unavailability_reason_card.dart';
import 'parent_profile_link.dart';
import 'profile_avatar.dart';
import 'profile_header_metadata.dart';
import 'profile_top_bar.dart';

class ProfileHeader extends StatelessWidget {
  final IndividualUserModel profileUser;
  final String displayName;
  final bool isOwnProfile;
  final bool isUnavailable;
  final ChatReason? chatReason;
  final void Function()? onParentPressed;
  final void Function()? onReportPressed;
  final void Function()? onBlockPressed;

  const ProfileHeader({
    super.key,
    required this.profileUser,
    required this.displayName,
    required this.isOwnProfile,
    required this.isUnavailable,
    required this.chatReason,
    required this.onParentPressed,
    required this.onReportPressed,
    required this.onBlockPressed,
  });

  String _metadataValue(String? value) {
    final String cleanValue = value?.trim() ?? '';
    return cleanValue.isEmpty ? LocaleKeys.notSetYet : cleanValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        16.w,
        10.h,
        16.w,
        20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileTopBar(
            onReportPressed: onReportPressed,
            onBlockPressed: onBlockPressed,
          ),
          16.szH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                avatarUrl: profileUser.avatar is String
                    ? profileUser.avatar as String
                    : null,
                displayName: displayName,
              ),
              14.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppText(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                        if (profileUser.isPromoted) ...[
                          8.szW,
                          const PremiumUserBadge(),
                        ],
                      ],
                    ),
                    10.szH,
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: [
                        ProfileHeaderMetadata(
                          icon: Assets.assets.svg.ageIcon.path,
                          value: _metadataValue(
                            profileUser.age == null
                                ? null
                                : '${profileUser.age} ${LocaleKeys.years}',
                          ),
                        ),
                        ProfileHeaderMetadata(
                          icon: Assets.assets.svg.location.path,
                          value: _metadataValue(profileUser.cityId?.name),
                        ),
                        ProfileHeaderMetadata(
                          icon: Assets.assets.svg.martialStatus.path,
                          value: _metadataValue(
                            profileUser.maritalStatus?.title,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (profileUser.childParentInfo != null) ...[
            14.szH,
            ParentProfileLink(
              parentInfo: profileUser.childParentInfo!,
              onPressed: onParentPressed!,
            ),
          ],
          if (isOwnProfile) ...[
            12.szH,
            AppText(
              '${LocaleKeys.numberOfProfileVisits} : ${profileUser.views ?? 0}',
              fontSize: 10.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ],
          if ((profileUser.bio?.trim().isNotEmpty ?? false)) ...[
            12.szH,
            AppText(
              profileUser.bio!,
              fontSize: 13.sp,
              height: 1.5,
              color: AppColors.darkGray,
            ),
          ],
          if (!isOwnProfile) ...[
            14.szH,
            isUnavailable
                ? const ChatAvailabilityBadge.notAvailable()
                : const ChatAvailabilityBadge.available(),
            if (isUnavailable) ...[
              10.szH,
              UnavailabilityReasonCard(reason: chatReason),
            ],
          ],
        ],
      ),
    );
  }
}
