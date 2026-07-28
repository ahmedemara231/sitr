import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import 'package:flutter_base/src/core/helpers/status_builder.dart';
import 'package:flutter_base/src/core/shared/base_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the supplied empty widget for an empty success list', (
    WidgetTester tester,
  ) async {
    const AsyncState<List<String>> state = AsyncState<List<String>>(
      status: BaseStatus.success,
      data: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StatusBuilder<List<String>>(
          data: state,
          emptyWidget: const Text('empty state'),
          onSuccess: (data, context) => const Text('success state'),
        ),
      ),
    );

    expect(find.text('empty state'), findsOneWidget);
    expect(find.text('success state'), findsNothing);
  });
}
