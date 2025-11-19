import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';

class DeleteSheet extends StatelessWidget {
  final FutureOr<void> Function(BuildContext) asyncCall;
  final String title;
  const DeleteSheet({super.key,
    required this.asyncCall,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.large(
        cancelBackgroundColor: AppColors.cancelColor,
        asyncCall: asyncCall,
        btnTitle: LocaleKeys.confirm,
        upperWidget: Column(
          children: [
            SizedBox.square(
                dimension: 200.sp,
                child: Image.asset(Assets.imagesDeleteIcon)
            ),
            AppText(title, fontWeight: FontWeight.w500),
          ],
        )
    );
  }
}
