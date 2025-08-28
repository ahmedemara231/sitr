import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../navigation/navigator.dart';
import '../app_text.dart';
import '../buttons/custom_app_buttons/default_button.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppText(LocaleKeys.swear, fontWeight: FontWeight.bold, fontSize: 16.sp),
        const AppText('texttexttexttexttexttexttexttexttexttext'),
        AppDefaultButton.withBackGroundColor(
            title: LocaleKeys.agree,
            onTap: (){
              // TODO: agree swear
            }
        )
      ],
    );
  }
}
