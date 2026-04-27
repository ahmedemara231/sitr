import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/res/config_imports.dart';

class RegisterStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<IconData>? icons;

  const RegisterStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.icons,
  });

  static const List<IconData> _defaultIcons = [
    Icons.person_outline,
    Icons.tune_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final resolved = icons ?? _defaultIcons;
    return EasyStepper(
      activeStep: currentStep - 1,
      direction: Axis.horizontal,
      lineStyle: LineStyle(
        lineType: LineType.normal,
        defaultLineColor: const Color(0xFFE0E0E0),
        finishedLineColor: AppColors.primary,
        lineThickness: 2,
        lineLength: 40.w,
      ),
      stepShape: StepShape.circle,
      stepRadius: 18.r,
      borderThickness: 1.5,
      showStepBorder: true,
      activeStepBackgroundColor: AppColors.primary,
      finishedStepBackgroundColor: AppColors.primary,
      unreachedStepBackgroundColor: Colors.white,
      activeStepBorderColor: AppColors.primary,
      activeStepIconColor: Colors.white,
      finishedStepIconColor: Colors.white,
      unreachedStepIconColor: AppColors.primary,
      internalPadding: 0,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      showLoadingAnimation: false,
      steps: List.generate(totalSteps, (i) {
        final iconData = resolved[i.clamp(0, resolved.length - 1)];
        return EasyStep(
          icon: Icon(iconData, size: 18.sp),
          activeIcon: Icon(iconData, size: 18.sp),
          finishIcon: Icon(Icons.check_rounded, size: 18.sp),
        );
      }),
    );
  }
}
