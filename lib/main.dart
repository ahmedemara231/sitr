import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart' as production;
import 'firebase_options_dev.dart' as dev;
import 'src/app.dart';
import 'src/config/language/languages.dart';
import 'src/config/res/config_imports.dart';
import 'src/core/helpers/apps_flyer/apps_flyer_helper.dart';
import 'src/core/helpers/helpers.dart';
import 'src/core/helpers/nsfw_detector.dart';
import 'src/core/local_db/objectbox_cache_service.dart';
import 'src/core/navigation/Constants/imports_constants.dart';
import 'src/core/navigation/go.dart';
import 'src/core/navigation/page_router/implementation/imports_page_router.dart';
import 'src/core/navigation/page_router/imports_page_router_builder.dart';
import 'src/core/helpers/cache_service.dart';
import 'src/core/network/backend_configuation.dart';
import 'src/core/network/dio_service.dart';
import 'src/core/network/fire_store.dart';
import 'src/core/shared/functions/setup_service_locators.dart';
import 'src/core/shared/bloc_observer.dart';
import 'src/core/widgets/custom_messages.dart';
import 'src/core/widgets/exeption_view.dart';

void _changeFireStoreAvailability(bool enable){
  if(enable){
    FireStoreService.instance.enableService();

  }else{
    FireStoreService.instance.disableService();
  }
}

Future<bool> fetchBaseUrl() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.fetchAndActivate();

    final bool fireStoreAvailabilityVal = remoteConfig.getBool(SecureLocalVariableKeys.fireStoreAvailabilityKey);
    _changeFireStoreAvailability(fireStoreAvailabilityVal);
    log('the fire store availability is $fireStoreAvailabilityVal');

    final String prodBaseUrl = remoteConfig.getString(SecureLocalVariableKeys.baseUrlKey);
    final String devBaseUrl = remoteConfig.getString(SecureLocalVariableKeys.devBaseUrlKey);
    final String socetIoUrl = remoteConfig.getString(SecureLocalVariableKeys.socetIoUrl);

    log('the prod base url is $prodBaseUrl');
    log('the dev base url is $devBaseUrl');
    log('the socket url is $socetIoUrl');

    if (socetIoUrl.isNotEmpty) {
      await SecureStorage.write(SecureLocalVariableKeys.socetIoUrl, socetIoUrl);
    }

    if (prodBaseUrl.isEmpty && devBaseUrl.isEmpty) {
      return false;
    }

    if (prodBaseUrl.isNotEmpty) {
      await SecureStorage.write(
          SecureLocalVariableKeys.baseUrlKey, prodBaseUrl);
    }
    if (devBaseUrl.isNotEmpty) {
      await SecureStorage.write(
          SecureLocalVariableKeys.devBaseUrlKey, devBaseUrl);
    }

    return true;
  } catch (e) {
    log('the error is $e');
    return false;
  }
}


Future<void> _initializeFirebaseApp() async {
  // Determine which Firebase options to use based on the flavor.
  // Fall back to production when the flavor is missing (e.g. launched from
  // Xcode without --flavor) so initialization never hard-crashes the launch.
  final firebaseOptions = switch (appFlavor) {
    'dev' => dev.DefaultFirebaseOptions.currentPlatform,
    'production' => production.DefaultFirebaseOptions.currentPlatform,
    _ => () {
        log('Unknown/empty appFlavor "$appFlavor" — defaulting Firebase to production options');
        return production.DefaultFirebaseOptions.currentPlatform;
      }(),
  };
  await Firebase.initializeApp(options: firebaseOptions);
}


void main() async {
  Helpers.changeStatusbarColor(
    statusBarColor: AppColors.white,
  );
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [
      EasyLocalization.ensureInitialized(),
      CacheStorage.init(),
      ObjectBoxCacheService.init(),
      ScreenUtil.ensureScreenSize(),
    ],
  );
  await _initializeFirebaseApp();
  await fetchBaseUrl();
  await Helpers.initZegoData();
  await AppyFlyerHelper.init();
  // final data = await FireStoreService.instance.getRequestData('count-notifications');
  // log('message::: ${data?.first.path}');
  try {
    await NsfwDetectorHelper.init();
  } on Exception catch (e) {
    MessageUtils.showTopMsg(e.toString());
  }

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  BackendConfiguation.setBackendType(BackendType.php);
  setUpServiceLocator();

  PageRouterBuilder().initAppRouter(
    config: PlatformConfig(
      android: CustomPageRouterCreator(
        parentTransition: TransitionType.fade,
        parentOptions: const FadeAnimationOptions(
          duration: Duration(milliseconds: 300),
        ),
      ),
    ),
  );
  if (kReleaseMode) {
    ErrorWidget.builder =
        (FlutterErrorDetails details) => const ExceptionView();
  }

  _initSentry();
}


void _initSentry()async{
  await SentryFlutter.init(
          (options) {
        options.dsn = 'https://cb95fd92d19a9f57924ae8dba99d9df4@o4508946921291776.ingest.us.sentry.io/4510555526070272';
        // Adds request headers and IP for users, for more info visit:
        // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
        options.sendDefaultPii = true;
      },
      appRunner: () => runApp(
        EasyLocalization(
          supportedLocales: Languages.suppoerLocales,
          path: 'assets/translations',
          saveLocale: true,
          startLocale: Languages.arabic.locale,
          // startLocale: Languages.getDeviceLocaleFromPlatform().locale,
          fallbackLocale: const Locale('ar'),
          child: const Satr(),
        ),
      )
  );
}
