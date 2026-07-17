part of '../../../imports.dart';

class _SignUpFieldsStep extends StatelessWidget {
  final _SignUpAccountType? accountType;
  final GlobalKey<FormState> formKey;
  final bool canSubmit;
  final Future<void> Function() onBackPressed;
  final Future<void> Function(BuildContext context) onSubmitPressed;
  final void Function(SignUpBody body) onSignUpBodyChanged;

  const _SignUpFieldsStep({
    required this.accountType,
    required this.formKey,
    required this.canSubmit,
    required this.onBackPressed,
    required this.onSubmitPressed,
    required this.onSignUpBodyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final _SignUpAccountType? selectedAccountType = accountType;

    if (selectedAccountType == null) {
      return const SizedBox.shrink();
    }

    return Form(
      key: formKey,
      child: Column(
        spacing: 16.h,
        children: [
          SignUpFields(
            key: ValueKey<String>(selectedAccountType.formKey),
            type: selectedAccountType.type,
            gender: selectedAccountType.gender,
            onFinish: (SignUpBody body) async => onSignUpBodyChanged(body),
          ),
          Row(
            children: [
              Expanded(
                child: DefaultButton(
                  title: LocaleKeys.back,
                  height: 45.h,
                  width: double.infinity,
                  color: AppColors.white,
                  borderColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                  textColor: AppColors.primary,
                  onTap: canSubmit ? () async => await onBackPressed() : null,
                ),
              ),
              10.szW,
              Expanded(
                child: AppLoadingButton(
                  borderRadius: 10.r,
                  asyncCall: onSubmitPressed,
                  title: LocaleKeys.confirm,
                  enabled: canSubmit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
