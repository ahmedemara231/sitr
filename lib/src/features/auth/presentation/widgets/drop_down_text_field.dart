import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';

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
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius,
              borderSide: const BorderSide(color: Colors.grey),
            ), // normal border
            focusedBorder: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius,
              borderSide: const BorderSide(color: Colors.grey,),
            ),
          ),
          initialValue: 'one',
          // initialValue: LocaleKeys.pleaseEnterTheType,
          items: const [
            DropdownMenuItem(
              value: 'one',
              child: Text('Option One'),
            ),
            DropdownMenuItem(
              value: 'two',
              child: Text('Option Two'),
            ),
            DropdownMenuItem(
              value: 'three',
              child: Text('Option Three'),
            ),
          ],
          onChanged: (val) {},
        ),
      ],
    );

  }
}
