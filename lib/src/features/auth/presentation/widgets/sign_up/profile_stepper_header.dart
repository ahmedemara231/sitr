part of '../../../imports.dart';

class _ProfileStepperHeader extends StatelessWidget {
  final List<_ProfileFormStep> steps;
  final int currentStep;
  final int maxReachedStep;
  final void Function(int index) onStepReached;

  const _ProfileStepperHeader({
    required this.steps,
    required this.currentStep,
    required this.maxReachedStep,
    required this.onStepReached,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.06),
            blurRadius: 24.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: EasyStepper(
        activeStep: currentStep,
        maxReachedStep: maxReachedStep,
        textDirection: Directionality.of(context),
        enableStepTapping: true,
        showLoadingAnimation: false,
        showStepBorder: false,
        stepRadius: 18.r,
        internalPadding: 4.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        lineStyle: LineStyle(
          lineLength: 24.w,
          lineThickness: 2.h,
          lineType: LineType.normal,
          unreachedLineType: LineType.normal,
          defaultLineColor: AppColors.border,
          unreachedLineColor: AppColors.border,
          activeLineColor: AppColors.primary,
          finishedLineColor: AppColors.primary,
        ),
        steps: steps.indexedMap(
          (int index, _ProfileFormStep step) => EasyStep(
            customStep: _ProfileStepIcon(
              iconPath: step.iconPath,
              isReached: index <= maxReachedStep,
              isActive: index == currentStep,
            ),
            customTitle: AppText(
              step.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: 10.sp,
              fontWeight:
                  index == currentStep ? FontWeight.bold : FontWeight.w500,
              color: index <= maxReachedStep
                  ? AppColors.primary
                  : AppColors.darkGay,
            ),
          ),
        ),
        onStepReached: onStepReached,
      ),
    );
  }
}

class _ProfileStepIcon extends StatelessWidget {
  final String iconPath;
  final bool isReached;
  final bool isActive;

  const _ProfileStepIcon({
    required this.iconPath,
    required this.isReached,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isReached ? AppColors.primary : AppColors.whiteGrey;
    final Color iconColor = isReached ? AppColors.white : AppColors.darkGay;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 36.r,
      height: 36.r,
      padding: EdgeInsets.all(9.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isActive
            ? Border.all(color: AppColors.primaryFixedDim, width: 2.w)
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 12.r,
                ),
              ]
            : null,
      ),
      child: IconWidget(
        icon: iconPath,
        color: iconColor,
        height: 18.r,
        width: 18.r,
      ),
    );
  }
}
