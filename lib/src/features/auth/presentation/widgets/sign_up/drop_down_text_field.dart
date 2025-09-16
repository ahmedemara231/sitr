import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../enums/answer.dart';

class DropDownTextField<T> extends StatefulWidget {
  final Answer withApiRequest;
  final Future<List<T>> Function(BuildContext context)? request;
  final String title;
  final void Function(T? val)? onChanged;
  final List<T>? values;
  final String hint;
  final Widget Function(T value)? itemBuilder;

  const DropDownTextField({
    super.key,
    required this.title,
    required this.values,
    required this.onChanged,
    required this.hint,
    this.itemBuilder,
  })  : withApiRequest = Answer.no,
        request = null;

  const DropDownTextField.withApiRequest({
    super.key,
    required this.title,
    required this.onChanged,
    required this.hint,
    required this.request,
    this.itemBuilder,
  })  : withApiRequest = Answer.yes,
        values = null;

  @override
  State<DropDownTextField<T>> createState() => _DropDownTextFieldState<T>();
}

class _DropDownTextFieldState<T> extends State<DropDownTextField<T>> {
  List<T> data = [];
  bool _isLoading = false;

  Future<void> _getDropdownData() async {
    setState(() => _isLoading = true);
    data = await widget.request!.call(context);
    log('finished');
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    if (widget.withApiRequest.isYes) {
      _getDropdownData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(widget.title, fontWeight: FontWeight.bold, fontSize: 11.sp),
        if (widget.withApiRequest.isNo)
          DropdownButtonFormField<T>(
            hint: AppText(widget.hint, color: Colors.grey),
            icon: const SvgPic(assetName: Assets.svgArrowDown),
            decoration: InputDecoration(
              fillColor: AppColors.whiteGreyColorProMax,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
              ),
            ),
            items: widget.values?.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: widget.itemBuilder?.call(value)?? AppText(value.toString()),
              );
            }).toList(),
            onChanged: widget.onChanged,
          )

        else
          DropdownButtonFormField<T>(
            hint: AppText(widget.hint, color: Colors.grey),
            icon: const SvgPic(assetName: Assets.svgArrowDown),
            decoration: InputDecoration(
              fillColor: AppColors.whiteGreyColorProMax,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: ConstantManager.buttonBorderRadius,
                borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
              ),
            ),

            items: _isLoading
                ? [
              DropdownMenuItem(
                value: null,
                enabled: false,
                child: Row(
                  children: [
                    CustomLoading.showLoadingView(),
                    const Text("Loading..."),
                  ],
                ),
              )
            ] : data.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: widget.itemBuilder?.call(value)?? AppText(value.toString()),
              );
            }).toList(),
            onChanged: widget.onChanged,
          )
      ],
    );
  }
}
