import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/src/config/res/config_imports.dart';
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

    await _pumpPackage(tester: tester, package: package);

    expect(find.text('الباقة الذهبية الاحترافية'), findsOneWidget);
    expect(find.text('عضوية مميزة طويلة المدى'), findsOneWidget);
    expect(find.text('30 يوم'), findsOneWidget);
    expect(find.byType(RiyalPriceText), findsOneWidget);
    expect(find.byType(DefaultButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a professional color theme for each price tier', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpThemePackage(
      tester: tester,
      package: _packageWithPrice(id: 1, price: 199),
    );
    expect(tester.widget<DefaultButton>(find.byType(DefaultButton)).color,
        AppColors.main);

    await _pumpThemePackage(
      tester: tester,
      package: _packageWithPrice(id: 2, price: 200),
    );
    expect(tester.widget<DefaultButton>(find.byType(DefaultButton)).color,
        AppColors.primary);

    await _pumpThemePackage(
      tester: tester,
      package: _packageWithPrice(id: 3, price: 500),
    );
    expect(tester.widget<DefaultButton>(find.byType(DefaultButton)).color,
        AppColors.forth);
    expect(tester.takeException(), isNull);
  });
}

Package _packageWithPrice({required int id, required num price}) => Package(
      id: id,
      name: 'باقة $id',
      type: PackageType('tier_$id', 'فئة $id'),
      image: '',
      duration: 30,
      price: price,
      hasActivePackage: false,
      packageId: id,
    );

Future<void> _pumpPackage({
  required WidgetTester tester,
  required Package package,
}) async {
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
  for (int attempt = 0;
      attempt < 10 && find.byType(DefaultButton).evaluate().isEmpty;
      attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pumpThemePackage({
  required WidgetTester tester,
  required Package package,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: PackageWidget(
            package: package,
            type: ScreenType.subscription,
            onSubscribe: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
