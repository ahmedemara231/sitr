import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_text.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText('text', fontWeight: FontWeight.bold, fontSize: 16.sp),
        const AppText('texttexttexttexttexttexttexttexttexttext'),

      ],
    );
  }
}
