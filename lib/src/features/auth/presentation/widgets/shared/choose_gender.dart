import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';

class ChooseGenderWidget extends StatefulWidget {
  final Function(UserType selectedGender) onSelectGender;
  final List<UserType> genders;

  const ChooseGenderWidget({super.key,
    required this.onSelectGender,
    required this.genders,
  });

  @override
  State<ChooseGenderWidget> createState() => _ChooseGenderWidgetState();
}

class _ChooseGenderWidgetState extends State<ChooseGenderWidget> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          widget.genders.length,
          (index) => Expanded(
            child: AppDefaultButton.withBackGroundColor(
              textColor: currentIndex == index? AppColors.white : AppColors.primary,
              title: widget.genders[index].translate,
              backgroundColor: currentIndex == index? AppColors.primary : Colors.white,
              onTap: () {
                setState(() => currentIndex = index);
                widget.onSelectGender(widget.genders[index]);
                },
            ).paddingSymmetric(horizontal: 10.w),
          )
      ),
    );
  }
}