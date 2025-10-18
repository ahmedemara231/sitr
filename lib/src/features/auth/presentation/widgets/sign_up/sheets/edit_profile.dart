import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../generated/assets.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../core/widgets/app_text.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        Lottie.asset(Assets.successDone),
        AppText(LocaleKeys.changesSavedSuccessfully, fontSize: 16.sp, fontWeight: FontWeight.w500),
      ],
    );
  }
}
