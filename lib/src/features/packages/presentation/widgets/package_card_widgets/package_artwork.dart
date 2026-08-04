import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../../core/widgets/svg_pic.dart';

class PackageArtwork extends StatelessWidget {
  final String imageUrl;

  const PackageArtwork({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.r,
      height: 72.r,
      padding: EdgeInsets.all(11.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.10),
            blurRadius: 18.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: CachedImage(
        url: imageUrl,
        fit: BoxFit.contain,
        bgColor: AppColors.transparent,
        borderColor: AppColors.transparent,
        placeHolder: SvgPic(
          assetName: Assets.svgPackagesScreenImage,
          size: 44.r,
        ),
      ),
    );
  }
}
