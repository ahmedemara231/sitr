import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';

class ChooseGenderWidget extends StatefulWidget {
  final Function(UserType selectedGender) onSelectGender;

  const ChooseGenderWidget({super.key,
    required this.onSelectGender,
  });

  @override
  State<ChooseGenderWidget> createState() => _ChooseGenderWidgetState();
}

class _ChooseGenderWidgetState extends State<ChooseGenderWidget> {
  final List<UserType> genders = [
    UserType.male,
    UserType.female,
    UserType.parent,
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          genders.length,
          (index) => Expanded(
            child: AppDefaultButton.withBackGroundColor(
              textColor: currentIndex == index? AppColors.white : AppColors.primary,
              title: genders[index].name.tr(),
              backgroundColor: currentIndex == index? AppColors.primary : Colors.white,
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