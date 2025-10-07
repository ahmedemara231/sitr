import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart' show Assets;
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_pic.dart';
import 'home_image.dart' show HomeImage;

class MarriageConsultantCard extends StatelessWidget {
  final String name;
  final String phone;
  final String parentImage;
  final String description;
  const MarriageConsultantCard({super.key,
    required this.name,
    required this.phone,
    required this.parentImage,
    required this.description,
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
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            children: [
              SizedBox.square(
                  dimension: 80.sp,
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
                      value: phone,
                      icon: Assets.svgConsultantPhone,
                      color: const Color(0xFFF57C00),
                      backgroundColor: const Color(0xFFFFF3E0),
                    ),

                  ],
                ),
              ),
            ],
          ),
          AppText(description, fontSize: 12.sp, color: Colors.grey)
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
          style: TextStyle(
            fontFamily: ConstantManager.fontFamily,
            fontSize: 16.sp,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
