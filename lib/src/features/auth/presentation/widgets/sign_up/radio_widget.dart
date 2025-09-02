import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';

// T is the dataType
class RadioWidget<T> extends StatefulWidget {
  final List<T> values;
  final List<Widget> titles;
  final String title;
  final FutureOr<void> Function(T val) onSubmit;
  final T? initialValue;

  const RadioWidget({super.key,
    required this.title,
    required this.onSubmit,
    required this.values,
    required this.titles,
    this.initialValue,
  }) : assert(values.length == titles.length);

  @override
  State<RadioWidget<T>> createState() => _RadioWidgetState<T>();
}

class _RadioWidgetState<T> extends State<RadioWidget<T>> {
  T? groupValue;
  void _changeValue(T? newVal){
    setState(() => groupValue = newVal);
    widget.onSubmit.call(groupValue!);
  }

  @override
  void initState() {
    groupValue = widget.initialValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(widget.title, fontWeight: FontWeight.bold, fontSize: 11.sp),
            Row(
              spacing: 10.h,
              children: List.generate(
                widget.values.length,
                    (index) => index != widget.values.length -1? _RadioItem<T?>(
                  title: widget.titles[index],
                  value: widget.values[index],
                  groupValue: groupValue,
                  onChanged: _changeValue,
                ) : Column(
                  children: [
                    _RadioItem<T?>(
                      title: widget.titles[index],
                      value: widget.values[index],
                      groupValue: groupValue,
                      onChanged: _changeValue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioItem<T> extends StatelessWidget {
  final Widget title;
  final T value;
  final T groupValue;
  final void Function(T? val) onChanged;

  const _RadioItem({super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        title,
      ],
    );
  }
}
