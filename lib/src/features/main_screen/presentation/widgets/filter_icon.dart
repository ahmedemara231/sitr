import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart' show Assets;
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/svg_pic.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Container(),
          // builder: (context) => const FilterWidget(),
        );
      },
      icon: Container(
        height: 45.h,
        width: 45.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const SvgPic(assetName: Assets.svgSortIcon).paddingAll(10.r),
      ).paddingSymmetric(horizontal: 10.w),
    );
  }
}
