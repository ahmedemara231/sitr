import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPic extends StatelessWidget {
  final String assetName;
  const SvgPic({super.key,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName);
  }
}