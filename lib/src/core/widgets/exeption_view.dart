import 'package:flutter/material.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/assets.gen.dart';
import '../../config/res/config_imports.dart';
import '../extensions/context_extension.dart';
import '../extensions/text_style_extensions.dart';
 

class ExceptionView extends StatelessWidget {
  const ExceptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: AppMargin.mH10,
        children: [
          AppAssets.lottie.error.apiError.lottie(),
          // Text(
          //   LocaleKeys.exceptionError,
          //   style: const TextStyle().setPrimaryColor.s13.medium,
          // ),
        ],
      ),
    );
  }
}
