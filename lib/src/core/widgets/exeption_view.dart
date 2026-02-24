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
    return FittedBox(
      child: Center(
        child: AppAssets.lottie.error.apiError.lottie(),
      ),
    );
  }
}
