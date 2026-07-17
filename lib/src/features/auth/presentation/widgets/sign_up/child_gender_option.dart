part of '../../../imports.dart';

class _ChildGenderOption extends StatelessWidget {
  final UserGender gender;
  final bool isSelected;
  final bool canChoose;
  final int? childrenCount;
  final void Function(UserGender gender) onGenderSelected;

  const _ChildGenderOption({
    required this.gender,
    required this.isSelected,
    required this.canChoose,
    required this.childrenCount,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isSelected ? AppColors.primary : AppColors.white;
    final Color foregroundColor =
        isSelected ? AppColors.white : AppColors.black;
    final Color borderColor = isSelected ? AppColors.primary : AppColors.border;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: canChoose ? () => onGenderSelected(gender) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
                '${gender.translate} ${childrenCount ?? 0}',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
