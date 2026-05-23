import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/icon_widget.dart';

class CustomIconInsideContainer extends StatelessWidget {
  const CustomIconInsideContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
  });

  final String icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white, shape: BoxShape.circle),
        child: IconWidget(icon: icon));
  }
}
