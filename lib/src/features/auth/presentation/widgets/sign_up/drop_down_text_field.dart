import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
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
  final T? initialValue;

  const DropDownTextField({
    super.key,
    required this.title,
    required this.values,
    required this.onChanged,
    required this.hint,
    this.itemBuilder,
    this.initialValue,
  })  : withApiRequest = Answer.no,
        request = null;

  const DropDownTextField.withApiRequest({
    super.key,
    required this.title,
    required this.onChanged,
    required this.hint,
    required this.request,
    this.itemBuilder,
    this.initialValue,
  })  : withApiRequest = Answer.yes,
        values = null;

  @override
  State<DropDownTextField<T>> createState() => _DropDownTextFieldState<T>();
}

class _DropDownTextFieldState<T> extends State<DropDownTextField<T>> {
  List<T> data = [];

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _getDropdownData(BuildContext context) async {
    if(data.isEmpty || data.isNull){
      _isLoading.value = true;
      data = await widget.request!.call(context);
      _isLoading.value = false;
    }
  }

  void _getData(BuildContext context)async{
    if (widget.withApiRequest.isYes) {
      await _getDropdownData(context);
    }
  }

  @override
  void initState() {
    _getData(context);
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
            initialValue: widget.initialValue,
            hint: AppText(widget.hint, color: Colors.grey),
            icon: SvgPic(assetName: Assets.assets.svg.arrowDown.path),
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
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (context, value, child) => Column(
              children: [
                InkWell(
                  onTap: () => _getData(context),
                  child: DropdownButtonFormField<T>(
                    isExpanded: !value,
                    initialValue: widget.initialValue,
                    hint: AppText(widget.hint, color: Colors.grey),
                    icon: SvgPic(assetName: Assets.assets.svg.arrowDown.path),
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

                    items: value? List.empty() :
                    data.map((T value) => DropdownMenuItem<T>(
                      value: value,
                      child: widget.itemBuilder?.call(value)?? AppText(value.toString()),
                    )).toList(),
                    onChanged: widget.onChanged,
                  ),
                ),

                if(value)
                  CustomLoading.showLoadingView()
              ],
            ),
          )
      ],
    );
  }
}
