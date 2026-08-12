import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/packages/presentation/packages_screen.dart';
import '../../navigation/navigator.dart';
import '../icon_widget.dart';
import 'chat_access_requirement_sheet.dart';

class AcceptChatRequestSubscriptionSheet extends StatelessWidget {
  const AcceptChatRequestSubscriptionSheet({super.key});

  Future<void> _openPackages() async {
    Go.back();
    unawaited(Go.to(const PackagesScreen.subscription()));
  }

  @override
  Widget build(BuildContext context) {
    return ChatAccessRequirementSheet(
      illustration: const _SubscriptionRequiredIllustration(),
      title: LocaleKeys.acceptChatRequestSubscriptionRequiredTitle,
      description: LocaleKeys.acceptChatRequestSubscriptionRequiredDescription,
      actionTitle: LocaleKeys.subscribeToPackage,
      onActionPressed: _openPackages,
    );
  }
}

class _SubscriptionRequiredIllustration extends StatelessWidget {
  const _SubscriptionRequiredIllustration();

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
              icon: Assets.assets.svg.packageIconSvg.path,
              color: AppColors.primary,
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
