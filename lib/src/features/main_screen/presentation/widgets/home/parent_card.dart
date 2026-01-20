import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/svg_pic.dart';
import 'home_image.dart';

class ParentCard extends StatelessWidget {
  final String parentImage;
  final String name;
  final String kinship;
  final int childrenNumber;

  const ParentCard({super.key,
    required this.parentImage,
    required this.name,
    required this.kinship,
    required this.childrenNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox.square(
              dimension: 65.sp,
              child: HomeImage(url: parentImage)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: ConstantManager.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),

                10.szH,
                // Row 1: Weight and Location
                _buildStatItem(
                  value: kinship,
                  icon: Assets.svgParentIcon,
                  color: const Color(0xFFF57C00),
                  backgroundColor: const Color(0xFFFFF3E0),
                ),
                _buildStatItem(
                  value: '$childrenNumber ${LocaleKeys.children}',
                  icon: Assets.svgParentChildren,
                  color: const Color(0xFFF57C00),
                  backgroundColor: const Color(0xFFFFF3E0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.sp,
            height: 16.sp,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPic(assetName: icon)
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: ConstantManager.fontFamily,
            fontSize: 14,
            color: Color(0xFF424242),
          ),
        ),
      ],
    );
  }
}
