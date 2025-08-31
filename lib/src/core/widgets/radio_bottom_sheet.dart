import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/padding_extension.dart';
import 'buttons/custom_app_buttons/loading_button.dart';

// T is the dataType
class RadioBottomSheet<T> extends StatefulWidget {
  final List<T> values;
  final List<Widget> titles;
  final String title;
  final FutureOr<void> Function(T val) onSubmit;
  final Color? btnColor;
  final String? btnTitle;
  final double? btnHeight;
  final T? initialValue;

  const RadioBottomSheet({super.key,
    required this.title,
    required this.onSubmit,
    required this.values,
    required this.titles,
    this.btnColor,
    this.btnTitle,
    this.btnHeight,
    this.initialValue,
  }) : assert(values.length == titles.length);

  @override
  State<RadioBottomSheet<T>> createState() => _RadioBottomSheetState<T>();
}

class _RadioBottomSheetState<T> extends State<RadioBottomSheet<T>> {
  T? groupValue;
  void _changeValue(T? newVal){
    setState(() => groupValue = newVal);
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
          spacing: 16.h,
          children: [
            AppText(widget.title, fontWeight: FontWeight.w500, fontSize: 22.sp),
            Column(
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
                    LoadingButton(
                      title: widget.btnTitle?? LocaleKeys.confirm,
                      asyncCall: () async => groupValue == null? null :
                      await widget.onSubmit(groupValue!),
                      height: widget.btnHeight?? 40.h,
                      color: groupValue == null?
                      Colors.grey[300] : widget.btnColor ?? AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).paddingAll(12.r),
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
        title,
        const Spacer(),
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
