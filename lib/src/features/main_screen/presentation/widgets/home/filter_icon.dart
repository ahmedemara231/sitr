import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart' show Assets;
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../screens/filter.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Go.to(const FilterScreen()),
      icon: Container(
        height: 45.h,
        width: 45.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPic(assetName: Assets.assets.svg.sortIcon.path).paddingAll(10.r),
      ).paddingSymmetric(horizontal: 10.w),
    );
  }
}
