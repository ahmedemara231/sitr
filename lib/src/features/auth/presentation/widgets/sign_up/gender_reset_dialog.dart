part of '../../../imports.dart';

class _GenderResetDialog extends StatelessWidget {
  const _GenderResetDialog();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.changeGender,
          textAlign: TextAlign.center,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
        12.szH,
        AppText(
          LocaleKeys.changeGenderWarning,
          textAlign: TextAlign.center,
          fontSize: 14.sp,
          color: AppColors.darkGay,
          height: 1.5,
        ),
        20.szH,
        DefaultButton(
          key: const ValueKey<String>('profile_gender_reset_confirm'),
          height: 54.h,
          width: double.infinity,
          borderRadius: BorderRadius.circular(50.r),
          customChild: AppText(
            LocaleKeys.changeAndReset,
            color: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          onTap: () => Go.back(true),
        ),
        10.szH,
        DefaultButton(
          key: const ValueKey<String>('profile_gender_reset_cancel'),
          height: 54.h,
          width: double.infinity,
          color: AppColors.white,
          borderColor: AppColors.primary,
          borderRadius: BorderRadius.circular(50.r),
          customChild: AppText(
            LocaleKeys.keepCurrentGender,
            color: AppColors.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          onTap: () => Go.back(false),
        ),
      ],
    );
  }
}
