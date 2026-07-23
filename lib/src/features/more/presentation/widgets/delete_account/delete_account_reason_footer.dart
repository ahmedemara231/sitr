import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';

class DeleteAccountReasonFooter extends StatelessWidget {
  const DeleteAccountReasonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        14.szH,
        AppText.withIcon(
          icon: Icon(
            Icons.info_outline,
            size: 12.r,
            color: AppColors.deleteAccountReasonSubtle,
          ),
          text: LocaleKeys.irreversibleDeleteAccountWarning,
          color: AppColors.deleteAccountReasonSubtle,
          fontSize: 11.5.sp,
          textAlign: TextAlign.center,
          height: 1.4,
        ),
      ],
    );
  }
}
