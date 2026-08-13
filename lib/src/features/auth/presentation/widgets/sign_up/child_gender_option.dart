part of '../../../imports.dart';

class _ChildGenderOption extends StatelessWidget {
  final UserGender gender;
  final bool isSelected;
  final int? childrenCount;
  final Future<void> Function(UserGender gender) onGenderSelected;

  const _ChildGenderOption({
    required this.gender,
    required this.isSelected,
    required this.childrenCount,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isSelected ? AppColors.primary : AppColors.whiteGrey;
    final Color foregroundColor =
        isSelected ? AppColors.white : AppColors.textBlack;
    final Color borderColor = isSelected ? AppColors.primary : AppColors.border;

    return InkWell(
      key: ValueKey<String>('profile_gender_${gender.name}'),
      borderRadius: BorderRadius.circular(12.r),
      onTap: () async => await onGenderSelected(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            _SignUpGenderRadio(isSelected: isSelected),
            12.szW,
            Expanded(
              child: AppText(
                gender.translate,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withValues(alpha: 0.16)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: AppText(
                '${childrenCount ?? 0}',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
