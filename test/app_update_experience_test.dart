import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/src/features/whats_new/widgets/upgrader_dialog.dart';
import 'package:flutter_base/src/features/whats_new/widgets/whats_new_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('renders the What’s New and updater dialog variants', (
    WidgetTester tester,
  ) async {
    await _pumpLocalized(
      tester,
      const WhatsNewSheet(
        version: '2.0.0',
        items: [
          'تحسين أول',
          'تحسين ثانٍ',
          'تحسين ثالث',
          'تحسين رابع',
          'تحسين خامس',
        ],
      ),
    );

    expect(find.text('ما الجديد؟'), findsOneWidget);
    expect(find.text('الإصدار 2.0.0'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);

    final Completer<void> storeCompleter = Completer<void>();
    await _pumpLocalized(
      tester,
      UpgraderDialog(
        isRequired: false,
        version: '2.0.0',
        onUpdatePressed: () => storeCompleter.future,
        onClosePressed: () {},
      ),
    );

    expect(find.text('يوجد تحديث جديد'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('جارٍ فتح المتجر...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    storeCompleter.complete();
    await tester.pumpAndSettle();

    await _pumpLocalized(
      tester,
      UpgraderDialog(
        isRequired: true,
        version: '2.0.0',
        onUpdatePressed: () async {},
        onClosePressed: null,
      ),
    );

    expect(find.text('تحديث مطلوب'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });
}

Future<void> _pumpLocalized(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: _TestApp(child: child),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: Scaffold(body: child),
      ),
    );
  }
}
