import 'package:flutter/material.dart';
import '../../config/res/assets.gen.dart';
 

class ExceptionView extends StatelessWidget {
  const ExceptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: AppAssets.lottie.error.apiError.lottie(),
      ),
    );
  }
}
