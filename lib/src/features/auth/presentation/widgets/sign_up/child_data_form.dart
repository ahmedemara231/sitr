part of '../../../imports.dart';

class _ChildDataForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final FirstValidationErrorFieldsBuilder validationFields;
  final _ProfileFormStep step;
  final Widget child;
  final bool canGoBack;
  final bool isFinalStep;
  final Future<void> Function() onBackPressed;
  final Future<void> Function() onContinuePressed;
  final Future<void> Function(BuildContext context) onSubmitPressed;

  const _ChildDataForm({
    super.key,
    required this.formKey,
    required this.validationFields,
    required this.step,
    required this.child,
    required this.canGoBack,
    required this.isFinalStep,
    required this.onBackPressed,
    required this.onContinuePressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FirstValidationErrorForm(
      formKey: formKey,
      validationFields: validationFields,
      onValid: () async {
        if (isFinalStep) {
          await onSubmitPressed(context);
          return;
        }
        await onContinuePressed();
      },
      builder: (BuildContext context, Future<void> Function() submit) =>
          _ProfileStepCard(
        step: step,
        actions: _ProfileStepActions(
          canGoBack: canGoBack,
          isFinalStep: isFinalStep,
          onBackPressed: onBackPressed,
          onContinuePressed: submit,
        ),
        child: child,
      ),
    );
  }
}
