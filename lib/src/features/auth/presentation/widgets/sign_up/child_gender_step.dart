part of '../../../imports.dart';

class _ChildGenderStep extends StatelessWidget {
  final UserGender? selectedGender;
  final int? maleNum;
  final int? femaleNum;
  final void Function(UserGender gender) onGenderSelected;
  final Future<void> Function() onContinuePressed;

  const _ChildGenderStep({
    required this.selectedGender,
    required this.maleNum,
    required this.femaleNum,
    required this.onGenderSelected,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonTitle = selectedGender == null
        ? LocaleKeys.confirm
        : '${LocaleKeys.continueAsA} ${selectedGender!.translate}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        AppText(
          LocaleKeys.gender,
          textAlign: TextAlign.center,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        AppText(
          LocaleKeys.pleaseEnterTheGender,
          textAlign: TextAlign.center,
          fontSize: 12.sp,
          color: AppColors.grey,
        ),
        4.szH,
        _ChildGenderOption(
          gender: UserGender.male,
          isSelected: selectedGender?.isMale ?? false,
          canChoose: true,
          childrenCount: maleNum,
          onGenderSelected: onGenderSelected,
        ),
        _ChildGenderOption(
          gender: UserGender.female,
          isSelected: selectedGender?.isFemale ?? false,
          canChoose: true,
          childrenCount: femaleNum,
          onGenderSelected: onGenderSelected,
        ),
        4.szH,
        DefaultButton(
          title: buttonTitle,
          height: 45.h,
          width: double.infinity,
          onTap: () async => await onContinuePressed(),
        ),
      ],
    );
  }
}
