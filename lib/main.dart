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
import 'firebase_options.dart';
import 'src/app.dart';
import 'src/config/language/languages.dart';
import 'src/config/res/config_imports.dart';
import 'src/core/helpers/helpers.dart';
import 'src/core/local_db/objectbox_cache_service.dart';
import 'src/core/navigation/Constants/imports_constants.dart';
import 'src/core/navigation/go.dart';
import 'src/core/navigation/page_router/implementation/imports_page_router.dart';
import 'src/core/navigation/page_router/imports_page_router_builder.dart';
import 'src/core/helpers/cache_service.dart';
import 'src/core/network/backend_configuation.dart';
import 'src/core/network/dio_service.dart';
import 'src/core/shared/functions/setup_service_locators.dart';
import 'src/core/shared/bloc_observer.dart';
import 'src/core/widgets/exeption_view.dart';

Future<bool> fetchBaseUrl() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set config settings for fetch timeout and minimum fetch interval
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero
      ),
    );

    // Fetch and activate the remote config
    await remoteConfig.fetchAndActivate();

    // Get the base URL from remote config
    final baseUrl = remoteConfig.getString(
      SecureLocalVariableKeys.baseUrlKey,
    );

    log('the base url is $baseUrl');

    // Get the Socet_Io URL from remote config
    final socetIoUrl = remoteConfig.getString(
      SecureLocalVariableKeys.socetIoUrl,
    );

    if (baseUrl.isEmpty) {
      return false;
    }

    await SecureStorage.write(SecureLocalVariableKeys.baseUrlKey, baseUrl);
    // await SecureStorage.write(SecureLocalVariableKeys.socetIoUrl, socetIoUrl);

    return true;
  } catch (e) {
    log('the error is $e');
    return false;
  }
}


void main() async {
  Helpers.changeStatusbarColor(
    statusBarColor: AppColors.white,
  );
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [
      Helpers.initZegoData(),
      EasyLocalization.ensureInitialized(),
      CacheStorage.init(),
      ObjectBoxCacheService.init(),
      ScreenUtil.ensureScreenSize(),
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    ],
  );

  await fetchBaseUrl();
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
          child: const RootRestorationScope(
              restorationId:'app',
              child: Sitr()
          ),
        ),
      )
  );
}
