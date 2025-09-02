import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/widgets/svg_pic.dart';

class DropDownTextField extends StatelessWidget {
  final String title;
  const DropDownTextField({super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontWeight: FontWeight.bold, fontSize: 11.sp),
        DropdownButtonFormField<String>(
          icon: const SvgPic(assetName: Assets.svgArrowDown),
          decoration: InputDecoration(
            fillColor: AppColors.whiteGreyColorProMax,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius,
              borderSide: const BorderSide(color: Colors.grey),
            ), // normal border
            enabledBorder: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius,
              borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
            ), //,
            focusedBorder: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius,
              borderSide: BorderSide(color: Colors.grey[300]!, width: 0),
            ),
          ),
          initialValue: '1',
          // initialValue: LocaleKeys.pleaseEnterTheType,
          items: List.generate(3, (index) => DropdownMenuItem(
            value: index.toString(),
            child: Text(index.toString()),
          ),),
          onChanged: (val) {},
        ),
      ],
    );

  }
}
