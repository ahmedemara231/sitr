import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/widgets/app_text.dart';

class PackagesTabBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTabChanged;

  const PackagesTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.whiteGrey,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PackagesTab(
              title: LocaleKeys.packages,
              isSelected: currentIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          Expanded(
            child: _PackagesTab(
              title: LocaleKeys.promotionSubscriptions,
              isSelected: currentIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackagesTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackagesTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(50.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            borderRadius: BorderRadius.circular(50.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AppText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: isSelected ? AppColors.white : AppColors.textBlack,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
