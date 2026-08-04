import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/widgets/buttons/default_button.dart';
import 'package:flutter_base/src/core/widgets/riyal_price_text.dart';
import 'package:flutter_base/src/features/packages/models/package.dart';
import 'package:flutter_base/src/features/packages/presentation/models/package_screen_type.dart';
import 'package:flutter_base/src/features/packages/presentation/widgets/package_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('renders the redesigned package card at the reference width', (
    WidgetTester tester,
  ) async {
    final Package package = Package(
      id: 1,
      name: 'الباقة الذهبية الاحترافية',
      type: PackageType('premium', 'عضوية مميزة طويلة المدى'),
      image: '',
      duration: 30,
      price: 299,
      hasActivePackage: false,
      packageId: 1,
    );

    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (BuildContext context, _) => MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PackageWidget(
                  package: package,
                  type: ScreenType.subscription,
                  onSubscribe: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('الباقة الذهبية الاحترافية'), findsOneWidget);
    expect(find.text('عضوية مميزة طويلة المدى'), findsOneWidget);
    expect(find.text('30 يوم'), findsOneWidget);
    expect(find.byType(RiyalPriceText), findsOneWidget);
    expect(find.byType(DefaultButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
