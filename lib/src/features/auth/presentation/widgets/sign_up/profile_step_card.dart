part of '../../../imports.dart';

class _ProfileStepCard extends StatelessWidget {
  final _ProfileFormStep step;
  final Widget child;
  final Widget actions;

  const _ProfileStepCard({
    super.key,
    required this.step,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.06),
            blurRadius: 28.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            step.title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          4.szH,
          AppText(
            LocaleKeys.completeProfileStepByStep,
            fontSize: 12.sp,
            color: AppColors.darkGay,
          ),
          16.szH,
          child,
          24.szH,
          actions,
        ],
      ),
    );
  }
}

class _ProfileStepActions extends StatelessWidget {
  final bool canGoBack;
  final bool isFinalStep;
  final Future<void> Function() onBackPressed;
  final Future<void> Function() onContinuePressed;

  const _ProfileStepActions({
    required this.canGoBack,
    required this.isFinalStep,
    required this.onBackPressed,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget continueButton = isFinalStep
        ? AppLoadingButton(
            key: const ValueKey<String>('profile_step_submit'),
            height: 54.h,
            borderRadius: 50.r,
            title: LocaleKeys.confirm,
            asyncCall: (BuildContext context) async =>
                await onContinuePressed(),
          )
        : DefaultButton(
            key: const ValueKey<String>('profile_step_continue'),
            height: 54.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(50.r),
            customChild: AppText(
              LocaleKeys.next,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            onTap: () async => await onContinuePressed(),
          );

    if (!canGoBack) {
      return continueButton;
    }

    return Row(
      children: [
        Expanded(
          child: DefaultButton(
            key: const ValueKey<String>('profile_step_back'),
            height: 54.h,
            width: double.infinity,
            color: AppColors.white,
            borderColor: AppColors.primary,
            borderRadius: BorderRadius.circular(50.r),
            customChild: AppText(
              LocaleKeys.back,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            onTap: () async => await onBackPressed(),
          ),
        ),
        12.szW,
        Expanded(child: continueButton),
      ],
    );
  }
}
