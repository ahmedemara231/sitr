import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/svg_pic.dart';
import 'home_image.dart';

class PartnerCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;
  final String weight;
  final int age;
  final double height;
  final String maritalStatus;

  const PartnerCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.weight,
    required this.age,
    required this.height,
    required this.maritalStatus,
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
              dimension: 80.sp,
              child: HomeImage(url: imageUrl)
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
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        value: location,
                        icon: Assets.svgLocation,
                        color: const Color(0xFFF57C00),
                        backgroundColor: const Color(0xFFFFF3E0),
                      ),
                      const SizedBox(width: 24),
                      _buildStatItem(
                        value: weight,
                        icon: Assets.svgWeight,
                        color: const Color(0xFF9C27B0),
                        backgroundColor: const Color(0xFFF3E5F5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        value: maritalStatus,
                        icon: Assets.svgMartialStatus,
                        color: const Color(0xFFF57C00),
                        backgroundColor: const Color(0xFFFFF3E0),
                      ),

                      const SizedBox(width: 24),
                      _buildStatItem(
                        value: '$age سنة',
                        icon: Assets.svgAgeIcon,
                        color: const Color(0xFF1976D2),
                        backgroundColor: const Color(0xFFE3F2FD),
                      ),

                      const SizedBox(width: 24),
                      _buildStatItem(
                        value: '$height سم',
                        icon: Assets.svgTallIcon,
                        color: const Color(0xFF616161),
                        backgroundColor: const Color(0xFFF5F5F5),
                      ),
                    ],
                  ),
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