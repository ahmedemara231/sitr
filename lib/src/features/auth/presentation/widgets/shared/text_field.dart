import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';

class SignUpTextField extends StatefulWidget {
  final String upperTitle;
  final String title;
  final String? suffixIconPath;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String?)? onChanged;
  final int? maxLength;

  const SignUpTextField({super.key,
    required this.upperTitle,
    required this.title,
    required this.controller,
    this.suffixIconPath,
    this.validator,
    this.inputType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLength,
  });

  @override
  State<SignUpTextField> createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {

  @override
  Widget build(BuildContext context) {
    return DefaultTextField.withTitle(
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      upperTitle: widget.upperTitle,
      title: widget.title,
      suffixIcon: widget.suffixIconPath.isNotNull?
      SvgPic(assetName: widget.suffixIconPath!).paddingAll(16) : null,
      fillColor: Colors.grey[50],
      borderRadius: ConstantManager.buttonBorderRadiusNumber,
      controller: widget.controller,
      validator: widget.validator,
      inputType: widget.inputType?? TextInputType.text,
    );
  }
}