import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../auth/presentation/widgets/shared/text_field.dart';

class FilterJobEducationWidget extends StatelessWidget {
  final TextEditingController currentJobController;
  final TextEditingController educationController;
  final void Function(String?) onJobChanged;
  final void Function(String?) onEducationChanged;

  const FilterJobEducationWidget({
    super.key,
    required this.currentJobController,
    required this.educationController,
    required this.onJobChanged,
    required this.onEducationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        SignUpTextField(
          upperTitle: LocaleKeys.currentJob,
          title: LocaleKeys.pleaseEnterTheCurrentJob,
          controller: currentJobController,
          onChanged: onJobChanged,
        ),
        SignUpTextField(
          upperTitle: LocaleKeys.educationalQualification,
          title: LocaleKeys.pleaseEnterTheEducationalQualification,
          controller: educationController,
          onChanged: onEducationChanged,
        ),
      ],
    );
  }
}
