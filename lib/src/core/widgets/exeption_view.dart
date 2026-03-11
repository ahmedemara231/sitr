import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/assets.dart';

class ExceptionView extends StatelessWidget {
  const ExceptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : screenSize.width;
        final height = constraints.maxHeight.isFinite ? constraints.maxHeight : screenSize.height;
        return Lottie.asset(
          Assets.errorErrorView,
          width: width,
          height: height,
        );
      },
    );
  }
}
