import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/extensions/padding_extension.dart';

class OnBoardingDots extends StatefulWidget {
  final int currentIndex;
  final int totalDotsNumber;
  const OnBoardingDots({super.key,
    required this.currentIndex,
    required this.totalDotsNumber
  });

  @override
  State<OnBoardingDots> createState() => _OnBoardingDotsState();
}

class _OnBoardingDotsState extends State<OnBoardingDots> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5.w,
      children: List.generate(
          widget.totalDotsNumber,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 10.h,
            width: widget.currentIndex == index? 20.w : 10.w,
            decoration: BoxDecoration(
                color: widget.currentIndex == index?
                AppColors.primary : Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.r)
            ),
          ),
      ),
    ).paddingSymmetric(vertical: 12.h);
  }
}