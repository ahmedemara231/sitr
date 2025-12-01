import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPic extends StatelessWidget {
  final String assetName;
  final Color? color;
  const SvgPic({super.key,
    required this.assetName,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName, color: color);
  }
}