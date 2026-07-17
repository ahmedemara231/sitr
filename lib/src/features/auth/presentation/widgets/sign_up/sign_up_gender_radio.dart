part of '../../../imports.dart';

class _SignUpGenderRadio extends StatelessWidget {
  final bool isSelected;

  const _SignUpGenderRadio({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.white : AppColors.primary,
          width: 1.5.w,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            )
          : null,
    );
  }
}
