import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/package.dart';
import 'package_artwork.dart';
import 'package_card_theme.dart';
import 'package_duration.dart';
import 'package_header_decoration.dart';
import 'package_price.dart';
import 'package_type_badge.dart';

class PackagePassHeader extends StatelessWidget {
  final Package package;
  final PackageCardTheme cardTheme;

  const PackagePassHeader({
    required this.package,
    required this.cardTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [cardTheme.accent, cardTheme.accentDark],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          PositionedDirectional(
            top: -50.r,
            end: -30.r,
            child: const PackageHeaderDecoration(size: 150),
          ),
          PositionedDirectional(
            bottom: -42.r,
            start: 86.r,
            child: const PackageHeaderDecoration(size: 96),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PackageArtwork(imageUrl: package.image),
                    14.szW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            package.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                          ),
                          if (package.type.title.trim().isNotEmpty) ...[
                            9.szH,
                            PackageTypeBadge(
                              title: package.type.title,
                              icon: cardTheme.icon,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                18.szH,
                Row(
                  children: [
                    PackageDuration(duration: package.duration),
                    16.szW,
                    Expanded(child: PackagePrice(price: package.price)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
