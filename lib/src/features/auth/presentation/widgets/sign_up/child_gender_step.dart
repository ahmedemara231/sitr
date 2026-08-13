part of '../../../imports.dart';

class _ChildGenderStep extends StatelessWidget {
  final UserGender? selectedGender;
  final int? maleNum;
  final int? femaleNum;
  final Future<void> Function(UserGender gender) onGenderSelected;

  const _ChildGenderStep({
    required this.selectedGender,
    required this.maleNum,
    required this.femaleNum,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.pleaseEnterTheGender,
          textAlign: TextAlign.center,
          fontSize: 12.sp,
          color: AppColors.darkGay,
        ),
        16.szH,
        _ChildGenderOption(
          gender: UserGender.male,
          isSelected: selectedGender?.isMale ?? false,
          childrenCount: maleNum,
          onGenderSelected: onGenderSelected,
        ),
        12.szH,
        _ChildGenderOption(
          gender: UserGender.female,
          isSelected: selectedGender?.isFemale ?? false,
          childrenCount: femaleNum,
          onGenderSelected: onGenderSelected,
        ),
      ],
    );
  }
}
