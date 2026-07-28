import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/default_button.dart';

class ConnectionRequestsEmptyView extends StatelessWidget {
  final void Function() onExploreProfilesPressed;

  const ConnectionRequestsEmptyView({
    required this.onExploreProfilesPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ConnectionRequestIllustration(),
            28.verticalSpace,
            AppText(
              LocaleKeys.noConnectionRequests,
              color: AppColors.textBlack,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            SizedBox(
              width: 250.w,
              child: AppText(
                LocaleKeys.connectionRequestsEmptyDescription,
                color: AppColors.darkGay,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
                textAlign: TextAlign.center,
              ),
            ),
            28.verticalSpace,
            DefaultButton(
              title: LocaleKeys.exploreProfiles,
              onTap: onExploreProfilesPressed,
              width: 270.w,
              height: 54.h,
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50.r),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              elevation: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionRequestIllustration extends StatelessWidget {
  const _ConnectionRequestIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 150.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 128.w,
            height: 128.w,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackShadow.withValues(alpha: 0.06),
                  blurRadius: 64.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Icon(
              Icons.person_add_alt_1_outlined,
              color: AppColors.darkGay.withValues(alpha: 0.40),
              size: 64.sp,
            ),
          ),
          PositionedDirectional(
            start: 0,
            top: 0,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryFixedDim,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
