import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../screens/sign_up.dart';

class DoNotHaveAccountWidget extends StatelessWidget {
  const DoNotHaveAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5.w,
      children: [
        AppText(LocaleKeys.doNotHaveAnAccount, color: Colors.grey, fontSize: 12.sp,),
        TextButton(
            onPressed: () => Go.to(const SignUpScreen()),
            child: AppText(
              LocaleKeys.newRegisteration,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            )
        ),
      ],
    );
  }
}
