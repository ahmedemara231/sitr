import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../shared/models/user_models/individual/individual_user_model.dart';
import '../../buttons/default_button.dart';
import '../../chat_button.dart';
import '../../request_actions.dart';

class ProfileActions extends StatelessWidget {
  final IndividualUserModel profileUser;
  final bool isOwnProfile;
  final Future<void> Function() onAcceptPressed;
  final Future<void> Function() onRejectPressed;
  final void Function() onEditPressed;

  const ProfileActions({
    super.key,
    required this.profileUser,
    required this.isOwnProfile,
    required this.onAcceptPressed,
    required this.onRejectPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOwnProfile) {
      if (profileUser.hasChatRequestFrom) {
        return RequestActions(
          canAccept: true,
          onAcceptPressed: onAcceptPressed,
          onRejectPressed: onRejectPressed,
        );
      }
      return ChatButton(user: profileUser);
    }

    return DefaultButton(
      height: 54.h,
      borderRadius: BorderRadius.circular(50.r),
      title: LocaleKeys.editProfile,
      onTap: onEditPressed,
    );
  }
}
