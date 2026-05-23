import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/app_logo_widget.dart';
import 'sign_up_static_texts.dart' show SignUpStaticTexts;

class SignUpUpperWidget extends StatelessWidget {
  const SignUpUpperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: context.width / 8,
          children: [
            // BlocProvider(
            //   create: (context) => ChangeLangCubit(),
            //   child: LangIcon(
            //       onSelectLang: (context, lang) async =>
            //       await context.read<ChangeLangCubit>().changeLang(lang.languageCode)
            //   ),
            // ),
            AppLogoWidget(),
          ],
        ),
        SignUpStaticTexts()
      ],
    ).paddingAll(12.r);
  }
}
