import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_text.dart';

class WhatsNewSheet extends StatelessWidget {
  final List<String> items;
  const WhatsNewSheet({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.small(
      btnTitle: LocaleKeys.whatsNewGotIt,
      asyncCall: (context) => Go.back(),
      upperWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          AppText(
            LocaleKeys.whatsNewTitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          ...items.map(
            (item) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.w,
              children: [
                AppText('•', fontSize: 16.sp),
                Expanded(child: AppText(item, fontSize: 16.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
