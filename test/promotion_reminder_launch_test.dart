import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/src/core/helpers/cache_service.dart';
import 'package:flutter_base/src/core/shared/models/user_models/user_model.dart';
import 'package:flutter_base/src/core/shared/user_cubit/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late UserCubit userCubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheStorage.init();
  });

  setUp(() async {
    await CacheStorage.deleteAll();
    userCubit = UserCubit();
    await userCubit.updateUser(
      UserModel.initial().copyWith(id: 42, isPromoted: false),
    );
  });

  tearDown(() async {
    await userCubit.close();
  });

  test('shows the promotion reminder on every third app launch', () async {
    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isTrue);

    await userCubit.resetPromotionReminderLaunchCount();

    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isTrue);
  });

  test('does not count launches for a promoted user', () async {
    await userCubit.updateUser(
      UserModel.initial().copyWith(id: 42, isPromoted: true),
    );

    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
    expect(await userCubit.registerPromotionReminderAppLaunch(), isFalse);
  });
}
