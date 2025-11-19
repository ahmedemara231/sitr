import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnerAppBarIcons extends StatelessWidget {
  final Widget icon;
  const PartnerAppBarIcons({super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.w,
        height: 40.h,
        decoration: const BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle
        ),
        child: icon,
    );
  }
}
