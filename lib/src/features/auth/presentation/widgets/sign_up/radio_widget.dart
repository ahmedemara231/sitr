import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/indexed_map.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';

class RadioWidget<T> extends StatefulWidget {
  final List<T> values;
  final Widget Function(int index) titleBuilder;
  final String title;
  final FutureOr<void> Function(T value) onSubmit;
  final T? initialValue;

  const RadioWidget({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.values,
    required this.titleBuilder,
    this.initialValue,
  });

  @override
  State<RadioWidget<T>> createState() => _RadioWidgetState<T>();
}

class _RadioWidgetState<T> extends State<RadioWidget<T>> {
  T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialValue;
  }

  Future<void> _changeValue(T value) async {
    setState(() => _groupValue = value);
    await widget.onSubmit.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          widget.title,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
        8.szH,
        Row(
          children: widget.values.indexedMap(
            (int index, T value) => Expanded(
              child: _RadioItem<T>(
                title: widget.titleBuilder.call(index),
                value: value,
                isSelected: _groupValue == value,
                onSelected: _changeValue,
              ).paddingEnd(
                index == widget.values.length - 1 ? 0 : 8.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioItem<T> extends StatelessWidget {
  final Widget title;
  final T value;
  final bool isSelected;
  final Future<void> Function(T value) onSelected;

  const _RadioItem({
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () async => await onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.whiteGrey,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textBlack,
            fontFamily: ConstantManager.fontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          child: title,
        ),
      ),
    );
  }
}
