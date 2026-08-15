import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/src/config/res/config_imports.dart';
import 'package:flutter_base/src/core/base_crud/code/domain/base_domain_imports.dart';
import 'package:flutter_base/src/core/base_crud/code/domain/usecases/pagination_response.dart';
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/helpers/user_type_enum.dart';
import 'package:flutter_base/src/core/navigation/navigator.dart';
import 'package:flutter_base/src/core/shared/convert_user_model_to_data_list_cubit.dart';
import 'package:flutter_base/src/core/shared/models/title_value_shape.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/female_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/individual_user_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/user_model.dart';
import 'package:flutter_base/src/core/widgets/view_profile_widget.dart';
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
      BaseCrudUseCase(repository: _UnusedBaseRepository()),
    );
  });

  tearDown(() async {
    await injector.reset();
  });

  testWidgets('renders profile details using the five profile form sections', (
    WidgetTester tester,
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
            home: ViewProfileWidget<_ProfileCubit>.profile(
              cubit: _ProfileCubit(_profile()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('المعلومات الأساسية'), findsOneWidget);
    expect(find.text('البيانات الشخصية'), findsOneWidget);
    expect(find.text('الأسرة والزواج'), findsOneWidget);
    expect(find.text('نمط الحياة والصحة'), findsOneWidget);
    expect(find.text('الدين والتفضيلات'), findsOneWidget);
    expect(find.text('ملتزمة'), findsOneWidget);
    expect(find.text('مع العائلة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

FemaleModel _profile() => FemaleModel(
      id: 10,
      name: 'نورة',
      nickName: 'نورة 2',
      gender: GenderValueShape(userGender: UserGender.female),
      isPromoted: true,
      views: 25,
      age: 36,
      phone: '512345678',
      maritalStatus: const TitleValueShape(
        title: 'عزباء',
        value: 'single',
      ),
      height: '165',
      weight: '65',
      cityId: CityModel(id: 1, name: 'منطقة علقان'),
      educationLevel: 'بكالوريوس',
      currentJob: 'موظفة',
      bio: 'نبذة مختصرة عن الملف الشخصي',
      hasChildren: false,
      wantChildren: true,
      dowry: Dowry(from: '25', to: '30'),
      weddingType: const TitleValueShape(
        title: 'فعالية متواضعة',
        value: 'simple',
      ),
      preferredResidenceAfterMarriage: 'مع العائلة',
      acceptsPolygamy: false,
      isSmoker: false,
      tribeAffiliation: true,
      skinColor: const TitleValueShape(title: 'قمحي', value: 'wheat'),
      chatLang: 'ar',
      healthConditions: '',
      isPrayer: true,
      religiousCommitment: const TitleValueShape(
        title: 'ملتزمة',
        value: 'committed',
      ),
      hijab: const TitleValueShape(title: 'محجبة', value: 'hijab'),
      prohibitedThings: 'عدم الاحترام',
    );

class _ProfileCubit extends GetUserModelCubit {
  final IndividualUserModel _profile;

  _ProfileCubit(this._profile);

  @override
  Future<void> getProfile({void Function(UserModel data)? onSuccess}) async {
    updateData(_profile);
    onSuccess?.call(_profile);
  }
}

class _UnusedBaseRepository implements BaseRepository {
  @override
  Future<Result<BaseModel<T>, Failure>> crudCall<T>(
    CrudBaseParmas<T> params,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<T>, Failure>> getBaseIdAndNameEntity<T extends BaseEntity>(
    GetBaseEntityParams? param,
  ) {
    throw UnimplementedError();
  }
}
