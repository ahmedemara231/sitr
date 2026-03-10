import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/assets.dart';

class ExceptionView extends StatelessWidget {
  const ExceptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.errorErrorView);
  }
}
