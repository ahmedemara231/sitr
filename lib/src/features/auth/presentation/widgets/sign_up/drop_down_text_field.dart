import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../enums/answer.dart';

class DropDownTextField<T> extends StatelessWidget {
  final Answer withApiRequest;
  final Future<List<T>> Function(BuildContext context)? request;
  final String title;
  final void Function(T? val)? onChanged;
  final List<T>? values;
  final String hint;
  final Widget Function(T value)? itemBuilder;
  final T? initialValue;

  DropDownTextField({
    super.key,
    required this.title,
    required this.values,
    required this.onChanged,
    required this.hint,
    this.itemBuilder,
    this.initialValue,
  })  : withApiRequest = Answer.no,
        request = null;

  DropDownTextField.withApiRequest({
    super.key,
    required this.title,
    required this.onChanged,
    required this.hint,
    required this.request,
    this.itemBuilder,
    this.initialValue,
  })  : withApiRequest = Answer.yes,
        values = null;

  List<T> data = [];

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final GlobalKey _dropDownKey = GlobalKey();

  Future<void> _getDropdownData(BuildContext context) async {
    if(data.isEmpty || data.isNull){
      _isLoading.value = true;
      data = await request!.call(context);
      _isLoading.value = false;
    }
  }

  void _getData(BuildContext context)async{
    if (withApiRequest.isYes) {
      await _getDropdownData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontWeight: FontWeight.bold, fontSize: 11.sp),
        if (withApiRequest.isNo)
          DropdownButtonFormField<T>(
            initialValue: initialValue,
            hint: AppText(hint, color: Colors.grey),
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
            items: values?.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: itemBuilder?.call(value)?? AppText(value.toString()),
              );
            }).toList(),
            onChanged: onChanged,
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
                    key: _dropDownKey,
                    initialValue: initialValue,
                    hint: AppText(hint, color: Colors.grey),
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

                    items: value? List.empty() :
                    data.map((T value) => DropdownMenuItem<T>(
                      value: value,
                      child: itemBuilder?.call(value)?? AppText(value.toString()),
                    )).toList(),
                    onChanged: onChanged,
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
