import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart'; // Ensure this path is correct
import '../../../../../config/res/config_imports.dart'; // Ensure this path is correct
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_pic.dart';

class DropDownTextField extends StatelessWidget {
  final String title;
  final void Function(String? val)? onChanged;
  final List<String> values; // This is your list of options e.g., ["ذكر", "انثى"]
  final String hint;
  final String? selectedValue; // Add this to hold the currently selected value

  const DropDownTextField({
    super.key,
    required this.title,
    required this.onChanged,
    required this.values,
    required this.hint,
    this.selectedValue, // Initialize it
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 10.h, // Column doesn't have a 'spacing' property. Use SizedBox for spacing.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontWeight: FontWeight.bold, fontSize: 11.sp),
        SizedBox(height: 10.h), // Use SizedBox for spacing
        DropdownButtonFormField<String>(
          value: selectedValue, // Set the current value of the dropdown
          hint: AppText(hint, color: Colors.grey),
          icon: const SvgPic(assetName: Assets.svgArrowDown), // Ensure Assets.svgArrowDown is correct
          decoration: InputDecoration(
            fillColor: AppColors.whiteGreyColorProMax, // Ensure AppColors is defined
            filled: true,
            border: OutlineInputBorder(
              borderRadius: ConstantManager.buttonBorderRadius, // Ensure ConstantManager is defined
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
          items: values.map((String value) { // Iterate over your list of strings
            return DropdownMenuItem<String>(
              value: value, // Assign the individual string value here
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          // The DropdownButtonFormField's 'value' must be one of the 'value' properties
          // of its 'DropdownMenuItem' list.
          // Ensure that 'selectedValue' passed to this widget is either null or
          // one of the strings present in the 'values' list.

          // validator: (value) { // Optional: Add a validator if needed
          //   if (value == null && values.isNotEmpty) { // values.isNotEmpty to avoid error if hint is the only option
          //     // return 'Please select an option'; // Or your desired error message
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }
}
