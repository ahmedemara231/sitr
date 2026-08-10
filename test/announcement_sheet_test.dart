import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/widgets/sheets/announcement_sheet.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Word HTML as rich announcement content', (
    WidgetTester tester,
  ) async {
    const String content = '<h2>عنوان فرعي</h2>'
        '<p>نص <strong>مهم</strong></p>'
        '<ul><li>البند الأول</li></ul>';

    await _pumpAnnouncement(
      tester: tester,
      wordContent: content,
    );

    expect(find.byKey(const Key('announcement_sheet')), findsOneWidget);
    expect(find.text('إعلان مهم'), findsOneWidget);
    expect(find.byType(Html), findsOneWidget);
    expect(tester.widget<Html>(find.byType(Html)).data, content);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preserves lines from plain Word text as paragraphs', (
    WidgetTester tester,
  ) async {
    await _pumpAnnouncement(
      tester: tester,
      wordContent: 'السطر الأول\nالسطر الثاني',
    );

    expect(
      tester.widget<Html>(find.byType(Html)).data,
      '<p>السطر الأول</p><p>السطر الثاني</p>',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('forwards an optional advertisement action', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await _pumpAnnouncement(
      tester: tester,
      wordContent: '<p>تفاصيل العرض</p>',
      actionTitle: 'عرض التفاصيل',
      onActionPressed: () async {
        wasPressed = true;
      },
    );

    await tester.tap(find.text('عرض التفاصيل'));
    await tester.pump();

    expect(wasPressed, isTrue);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpAnnouncement({
  required WidgetTester tester,
  required String wordContent,
  String actionTitle = 'إغلاق',
  Future<void> Function()? onActionPressed,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: AnnouncementSheet(
              onActionPressed: onActionPressed,
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pump();
}
