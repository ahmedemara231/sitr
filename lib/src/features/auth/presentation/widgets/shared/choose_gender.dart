import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../../core/widgets/custom_messages.dart';

class ChooseGenderWidget extends StatefulWidget {
  final Function(UserGender selectedGender) onSelectGender;
  final List<UserGender> genders;
  final bool canChoose;
  final String Function(UserGender element) titles;

  const ChooseGenderWidget({super.key,
    required this.onSelectGender,
    required this.genders,
    required this.canChoose,
    required this.titles
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
              title: widget.titles.call(widget.genders[index]),
              backgroundColor: currentIndex == index? AppColors.primary : Colors.white,
              onTap: () {
                if(widget.canChoose){
                  setState(() => currentIndex = index);
                  widget.onSelectGender(widget.genders[index]);

                }else{
                  MessageUtils.show(
                    LocaleKeys.waitUntilTheCurrentSignUpCompleted,
                    state: MsgState.info,
                  );
                }},
            ).paddingSymmetric(horizontal: 10.w),
          )
      ),
    );
  }
}
