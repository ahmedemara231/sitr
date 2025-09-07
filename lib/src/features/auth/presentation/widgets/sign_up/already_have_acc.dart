import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/widgets/app_text.dart';

class AlreadyHaveAccWidget extends StatelessWidget {
  const AlreadyHaveAccWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(LocaleKeys.alreadyHaveAnAccount, fontSize: 12.sp, color: Colors.grey,),
        AppText(LocaleKeys.login, fontSize: 12.sp, color: AppColors.primary),
      ],
    );
  }
}
