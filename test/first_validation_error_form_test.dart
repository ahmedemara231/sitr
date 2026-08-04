import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/src/core/widgets/first_validation_error_form.dart';

void main() {
  testWidgets('reports the first error and submits after validation succeeds', (
    WidgetTester tester,
  ) async {
    final GlobalKey fieldKey = GlobalKey();
    String value = '';
    FirstValidationError? validationError;
    bool didSubmit = false;

    String? validator(String? input) =>
        input?.trim().isEmpty ?? true ? 'required' : null;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FirstValidationErrorForm(
            showToast: false,
            scrollToField: false,
            validationFields: () => <FirstValidationErrorField>[
              FirstValidationErrorField(
                fieldKey: fieldKey,
                title: 'Name',
                value: value,
                validator: validator,
              ),
            ],
            onValidationError: (error) => validationError = error,
            onValid: () => didSubmit = true,
            builder: (context, submit) {
              return Column(
                children: [
                  TextFormField(
                    key: fieldKey,
                    onChanged: (input) => value = input,
                    validator: validator,
                  ),
                  ElevatedButton(onPressed: submit, child: const Text('Save')),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(validationError?.field.title, 'Name');
    expect(validationError?.message, 'required');
    expect(didSubmit, isFalse);

    await tester.enterText(find.byType(TextFormField), 'Valid name');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(didSubmit, isTrue);
  });
}
