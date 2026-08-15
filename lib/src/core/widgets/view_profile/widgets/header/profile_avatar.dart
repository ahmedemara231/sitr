import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../app_text.dart';
import '../../../image_widgets/cached_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.displayName,
  });

  String get _initial {
    final String value = displayName.trim();
    if (value.isEmpty) {
      return '';
    }
    return String.fromCharCode(value.runes.first);
  }

  Widget _placeholder() {
    return Container(
      width: 80.r,
      height: 80.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.10),
        ),
      ),
      child: AppText(
        _initial,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = avatarUrl?.trim() ?? '';
    if (url.isEmpty) {
      return _placeholder();
    }
    return CachedImage(
      url: url,
      width: 80.r,
      height: 80.r,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(13.r),
      placeHolder: _placeholder(),
      bgColor: AppColors.offWhite,
    );
  }
}
