import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/res/config_imports.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import 'app_text.dart';

class ChooseFromOptionsWidget extends StatefulWidget {
  final void Function(String selectedOption) onSelectOption;
  final bool secondSlider;
  final List<String> titles;
  final double fontSize;
  final FontWeight? fontWeight;

  const ChooseFromOptionsWidget({super.key,
    required this.onSelectOption,
    required this.titles,
    this.secondSlider = false,
    this.fontSize = 10,
    this.fontWeight
  });

  @override
  State<ChooseFromOptionsWidget> createState() => _ChooseFromOptionsWidgetState();
}

class _ChooseFromOptionsWidgetState extends State<ChooseFromOptionsWidget> {
  late String option = widget.titles.first;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        spacing: widget.secondSlider? 16.w : 0,
        mainAxisAlignment: widget.secondSlider?
        MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.titles.length,
              (index) => InkWell(
            onTap: () {
              final String selectedOption = widget.titles[index];
              widget.onSelectOption(selectedOption);
              setState(() => option = selectedOption);
            },
            child: Container(
              width: context.width / widget.titles.length,
              decoration: BoxDecoration(
                color: option == widget.titles[index] ?
                AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: FittedBox(
                  child: AppText(
                    widget.titles[index],
                    color: option == widget.titles[index] ?
                    Colors.white : AppColors.black,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight ?? FontWeight.normal,
                  ).paddingSymmetric(vertical: widget.secondSlider? 10.h : 18.h, horizontal: widget.secondSlider ? 30.w : 18.w),
                ),
              ),
            ),
          ),
        ),
      ).paddingSymmetric(vertical: 10.h),
    );
  }
}