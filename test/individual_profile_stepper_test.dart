import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/src/config/res/config_imports.dart';
import 'package:flutter_base/src/core/base_crud/code/domain/base_domain_imports.dart';
import 'package:flutter_base/src/core/base_crud/code/domain/usecases/pagination_response.dart';
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/helpers/user_type_enum.dart';
import 'package:flutter_base/src/core/navigation/navigator.dart';
import 'package:flutter_base/src/core/shared/models/title_value_shape.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/individual_user_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/male_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/user_model.dart';
import 'package:flutter_base/src/features/auth/imports.dart';
import 'package:flutter_base/src/features/auth/models/dowry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    await injector.reset();
    injector.registerSingleton<BaseCrudUseCase>(
      BaseCrudUseCase(repository: _FakeBaseRepository()),
    );
  });

  tearDown(() async {
    await injector.reset();
  });

  testWidgets('wizard retains its draft and submits only from the final step', (
    WidgetTester tester,
  ) async {
    bool didSubmit = false;
    final ValueNotifier<Widget> activeScreen = ValueNotifier<Widget>(
      EnterMaleOrFemaleOrChildDataScreen.showAll(
        scaffoldType: ScaffoldType.appScaffold,
        onClick: (BuildContext context, IndividualUserModel user) async {
          didSubmit = true;
        },
      ),
    );
    addTearDown(activeScreen.dispose);
    await _pumpProfileScreen(
      tester,
      ValueListenableBuilder<Widget>(
        valueListenable: activeScreen,
        builder: (BuildContext context, Widget screen, Widget? child) => screen,
      ),
    );

    expect(find.byType(EasyStepper), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('profile_gender_male')),
        findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('profile_gender_male')),
    );
    await _tapStepAction(tester, 'profile_step_continue');
    await tester.pumpAndSettle();

    final Finder mainFields = find.byType(TextFormField);
    expect(mainFields, findsNWidgets(4));
    await tester.enterText(mainFields.at(1), 'Saved nickname');

    await _tapStepAction(tester, 'profile_step_back');
    await tester.pumpAndSettle();
    await _tapStepAction(tester, 'profile_step_continue');
    await tester.pumpAndSettle();

    final TextFormField nicknameField =
        tester.widget<TextFormField>(find.byType(TextFormField).at(1));
    expect(nicknameField.controller?.text, 'Saved nickname');
    expect(didSubmit, isFalse);

    await _tapStepAction(tester, 'profile_step_back');
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('profile_gender_female')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('profile_gender_reset_cancel')),
    );
    await tester.pumpAndSettle();
    await _tapStepAction(tester, 'profile_step_continue');
    await tester.pumpAndSettle();
    TextFormField retainedNickname =
        tester.widget<TextFormField>(find.byType(TextFormField).at(1));
    expect(retainedNickname.controller?.text, 'Saved nickname');

    await _tapStepAction(tester, 'profile_step_back');
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('profile_gender_female')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('profile_gender_reset_confirm')),
    );
    await tester.pumpAndSettle();
    await _tapStepAction(tester, 'profile_step_continue');
    await tester.pumpAndSettle();
    retainedNickname =
        tester.widget<TextFormField>(find.byType(TextFormField).at(1));
    expect(retainedNickname.controller?.text, isEmpty);

    int submitCount = 0;
    IndividualUserModel? submittedModel;
    final MaleModel initialModel = _validMaleModel();
    activeScreen.value = EnterMaleOrFemaleOrChildDataScreen.individual(
      key: const ValueKey<String>('valid_profile_flow'),
      scaffoldType: ScaffoldType.appScaffold,
      userType: UserGender.male,
      initialValue: initialModel,
      onClick: (BuildContext context, IndividualUserModel user) async {
        submitCount++;
        submittedModel = user;
      },
    );
    await tester.pumpAndSettle();

    for (int step = 0; step < 4; step++) {
      await _tapStepAction(tester, 'profile_step_continue');
      await tester.pumpAndSettle();
      expect(submitCount, 0);
    }

    expect(
      find.byKey(const ValueKey<String>('profile_step_submit')),
      findsOneWidget,
    );
    await _tapStepAction(tester, 'profile_step_submit');
    await tester.pumpAndSettle();

    expect(submitCount, 1);
    expect(submittedModel, isA<MaleModel>());
    expect(submittedModel?.nickName, initialModel.nickName);
  });
}

MaleModel _validMaleModel() {
  const TitleValueShape maritalStatus = TitleValueShape(
    title: 'Single',
    value: 'single',
  );
  const TitleValueShape genericSelection = TitleValueShape(
    title: 'Selected',
    value: 'selected',
  );

  return MaleModel(
    gender: GenderValueShape(userGender: UserGender.male),
    nickName: 'Nickname',
    maritalStatus: maritalStatus,
    height: '180',
    weight: '80',
    currentJob: 'Engineer',
    bio: 'A complete profile biography',
    hasChildren: false,
    wantChildren: true,
    prohibitedThings: 'Disrespectful communication',
    dowry: Dowry(from: '1000', to: '2000'),
    weddingType: genericSelection,
    cityId: CityModel(id: 1, name: 'Riyadh'),
    educationLevel: 'University degree',
    isPrayer: true,
    healthConditions: '',
    chatLang: 'ar',
    isSmoker: false,
    tribeAffiliation: false,
    skinColor: genericSelection,
    religiousCommitment: genericSelection,
  );
}

Future<void> _pumpProfileScreen(
  WidgetTester tester,
  Widget screen,
) async {
  tester.view.physicalSize = const Size(390, 1000);
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
        builder: (BuildContext context, Widget? child) => MaterialApp(
          navigatorKey: Go.navigatorKey,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: screen,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  for (int attempt = 0;
      attempt < 10 && find.byType(EasyStepper).evaluate().isEmpty;
      attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
  expect(find.byType(EasyStepper), findsOneWidget);
}

Future<void> _tapStepAction(WidgetTester tester, String key) async {
  final Finder action = find.byKey(ValueKey<String>(key));
  expect(action, findsOneWidget);
  await tester.ensureVisible(action);
  await tester.pumpAndSettle();
  await tester.tap(action);
}

class _FakeBaseRepository implements BaseRepository {
  @override
  Future<Result<BaseModel<T>, Failure>> crudCall<T>(
    CrudBaseParmas<T> params,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<T>, Failure>> getBaseIdAndNameEntity<T extends BaseEntity>(
      GetBaseEntityParams? param) {
    throw UnimplementedError();
  }
}
