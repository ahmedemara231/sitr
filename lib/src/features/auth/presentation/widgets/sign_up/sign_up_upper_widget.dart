import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/app_logo_widget.dart';
import '../../../../../core/widgets/lang_icon.dart';
import 'sign_up_static_texts.dart' show SignUpStaticTexts;

class SignUpUpperWidget extends StatelessWidget {
  const SignUpUpperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        Row(
          spacing: context.width / 8,
          children: [
            LangIcon(onSelectLang: (lang){}),
            const AppLogoWidget(),
          ],
        ),
        const SignUpStaticTexts()
      ],
    ).paddingAll(12.r);
  }
}
