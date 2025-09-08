import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../screens/login.dart';

class AlreadyHaveAccWidget extends StatelessWidget {
  const AlreadyHaveAccWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(LocaleKeys.alreadyHaveAnAccount, fontSize: 12.sp, color: Colors.grey,),
        TextButton(
            onPressed: () => Go.offAll(const LoginScreen()),
            child: AppText(LocaleKeys.login, fontSize: 12.sp, color: AppColors.primary)
        ),
      ],
    );
  }
}
