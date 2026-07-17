part of '../../../imports.dart';

class _ChildGenderFirstFlow extends StatelessWidget {
  final int currentPage;
  final ValueNotifier<UserGender?> selectedChildGender;
  final int? maleNum;
  final int? femaleNum;
  final void Function(UserGender gender) onGenderSelected;
  final Future<void> Function() onContinuePressed;
  final Widget dataForm;

  const _ChildGenderFirstFlow({
    required this.currentPage,
    required this.selectedChildGender,
    required this.maleNum,
    required this.femaleNum,
    required this.onGenderSelected,
    required this.onContinuePressed,
    required this.dataForm,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      child: currentPage == 0
          ? ValueListenableBuilder<UserGender?>(
              key: const ValueKey<String>('child_gender_step'),
              valueListenable: selectedChildGender,
              builder: (context, selectedGender, child) => _ChildGenderStep(
                selectedGender: selectedGender,
                maleNum: maleNum,
                femaleNum: femaleNum,
                onGenderSelected: onGenderSelected,
                onContinuePressed: onContinuePressed,
              ),
            )
          : KeyedSubtree(
              key: const ValueKey<String>('child_data_form'),
              child: dataForm,
            ),
    );
  }
}
