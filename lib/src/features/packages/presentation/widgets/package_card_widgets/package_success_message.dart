import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';

class PackageSuccessMessage extends StatelessWidget {
  final bool isInAuth;

  const PackageSuccessMessage({required this.isInAuth, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          LocaleKeys.paymentSucceeded,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        if (isInAuth) ...[
          10.szH,
          AppText(LocaleKeys.youCanNowCompleteYourProfile),
        ],
      ],
    );
  }
}
