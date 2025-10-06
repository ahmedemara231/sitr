import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';

enum Options{first, second}

class UnderSliderWidget extends StatefulWidget {

  final void Function(Options selectedOption) onSelectOption;
  final bool secondSlider;
  final List<String> titles;
  final double fontSize;
  final FontWeight? fontWeight;

  const UnderSliderWidget({super.key,
    required this.onSelectOption,
    required this.titles,
    this.secondSlider = false,
    this.fontSize = 10,
    this.fontWeight
  });

  @override
  State<UnderSliderWidget> createState() => _UnderSliderWidgetState();
}

class _UnderSliderWidgetState extends State<UnderSliderWidget> {
  Options option = Options.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: widget.secondSlider? 16.w : 0,
      mainAxisAlignment: widget.secondSlider?
      MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.titles.length,
            (index) => InkWell(
          onTap: () {
            final Options selectedOption = Options.values[index];
            widget.onSelectOption(selectedOption);
            setState(() => option = selectedOption);
          },
          child: Container(
            decoration: BoxDecoration(
              color: option == Options.values[index] ?
              AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: AppText(
              widget.titles[index],
              color: option == Options.values[index] ?
              Colors.white : AppColors.black,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight ?? FontWeight.normal,
            ).paddingSymmetric(vertical: widget.secondSlider? 10.h : 18.h, horizontal: widget.secondSlider ? 30.w : 18.w),
          ),
        ),
      ),
    ).paddingSymmetric(vertical: 10.h);
  }
}