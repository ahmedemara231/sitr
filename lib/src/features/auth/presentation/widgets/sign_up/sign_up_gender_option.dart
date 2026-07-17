part of '../../../imports.dart';

class _SignUpGenderOption extends StatelessWidget {
  final _SignUpAccountType accountType;
  final bool isSelected;
  final bool canChoose;
  final void Function(_SignUpAccountType accountType) onAccountTypeSelected;

  const _SignUpGenderOption({
    required this.accountType,
    required this.isSelected,
    required this.canChoose,
    required this.onAccountTypeSelected,
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
      onTap: canChoose ? () => onAccountTypeSelected(accountType) : null,
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
                accountType.title,
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
