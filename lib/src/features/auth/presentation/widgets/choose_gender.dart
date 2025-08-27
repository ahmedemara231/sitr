import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/gender_enum.dart';
import '../../../../core/widgets/buttons/default_button.dart';

class ChooseGenderWidget extends StatefulWidget {
  final Function(Gender selectedGender) onSelectGender;

  const ChooseGenderWidget({super.key,
    required this.onSelectGender,
  });

  @override
  State<ChooseGenderWidget> createState() => _ChooseGenderWidgetState();
}

class _ChooseGenderWidgetState extends State<ChooseGenderWidget> {
  final List<Gender> genders = [
    Gender.male,
    Gender.female,
    Gender.parent,
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          genders.length,
          (index) => Expanded(
            child: DefaultButton(
              borderRadius: ConstantManager.buttonBorderRadius,
              color: currentIndex == index? AppColors.primary : Colors.grey,
              title: genders[index].name.tr(),
              onTap: () {
                setState(() => currentIndex = index);
                widget.onSelectGender(genders[index]);
              },
            ).paddingSymmetric(horizontal: 10.w),
          )
      ),
    );
  }
}