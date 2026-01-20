import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../data/models/home_model.dart';
import 'home_image.dart';

class PartnerCard extends StatelessWidget {
  final bool _withParent;
  final Opportunity opportunity;

  const PartnerCard.individual({
    super.key,
    required this.opportunity
  }) : _withParent = false;

  const PartnerCard.withParent({
    super.key,
    required this.opportunity
  }) : _withParent = true;


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
              child: HomeImage(url: opportunity.avatar ?? ConstantManager.defaultAvatar)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity.name ?? '',
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
                      if(_withParent)
                        if(opportunity.gender?.userGender?.isFemale?? false)
                          _buildStatItem(
                            value: opportunity.hijab?.title ?? '',
                            icon: Assets.svgHijab,
                            color: const Color(0xFFF57C00),
                            backgroundColor: const Color(0xFFFFF3E0),
                          )else
                            _buildStatItem(
                              value: opportunity.skin?.title ?? '',
                              icon: Assets.svgParentIcon,
                              color: const Color(0xFFF57C00),
                              backgroundColor: const Color(0xFFFFF3E0),
                            )
                      else
                        _buildStatItem(
                          value: opportunity.city?? '',
                          icon: Assets.svgLocation,
                          color: const Color(0xFFF57C00),
                          backgroundColor: const Color(0xFFFFF3E0),
                        ),

                      const SizedBox(width: 24),
                      _buildStatItem(
                        value: '${opportunity.weight} ${LocaleKeys.kg}',
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
                    spacing: 24.w,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(!_withParent)
                      _buildStatItem(
                        value: opportunity.martialStatus?.title ?? '',
                        icon: Assets.svgMartialStatus,
                        color: const Color(0xFFF57C00),
                        backgroundColor: const Color(0xFFFFF3E0),
                      ),

                      _buildStatItem(
                        value: '${opportunity.age} ${LocaleKeys.years}',
                        icon: Assets.svgAgeIcon,
                        color: const Color(0xFF1976D2),
                        backgroundColor: const Color(0xFFE3F2FD),
                      ),

                      _buildStatItem(
                        value: '${opportunity.height} ${LocaleKeys.centimeter}',
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