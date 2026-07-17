part of '../../../imports.dart';

class _SignUpGenderStep extends StatelessWidget {
  final _SignUpAccountType? selectedAccountType;
  final bool canChoose;
  final void Function(_SignUpAccountType accountType) onAccountTypeSelected;
  final Future<void> Function() onContinuePressed;

  const _SignUpGenderStep({
    required this.selectedAccountType,
    required this.canChoose,
    required this.onAccountTypeSelected,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonTitle = selectedAccountType == null
        ? LocaleKeys.confirm
        : '${LocaleKeys.continueAsA} ${selectedAccountType!.title}';

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
        ...List.generate(
          _SignUpAccountType.values.length,
          (int index) {
            final _SignUpAccountType accountType =
                _SignUpAccountType.values[index];

            return _SignUpGenderOption(
              accountType: accountType,
              isSelected: selectedAccountType == accountType,
              canChoose: canChoose,
              onAccountTypeSelected: onAccountTypeSelected,
            );
          },
        ),
        4.szH,
        DefaultButton(
          title: buttonTitle,
          height: 45.h,
          width: double.infinity,
          onTap: canChoose ? () async => await onContinuePressed() : null,
        ),
      ],
    );
  }
}
