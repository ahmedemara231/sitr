import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pip_view/pip_view.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'config/language/locale_keys.g.dart';
import 'config/res/config_imports.dart';
import 'core/helpers/user_type_enum.dart';
import 'core/navigation/navigator.dart';
import 'core/shared/route_observer.dart';
import 'core/shared/user_cubit/user_cubit.dart' show UserCubit;
import 'core/widgets/custom_messages.dart';
import 'features/auth/imports.dart';
import 'features/home/cubits/get_notification_count.dart';
import 'features/on_boarding/screen.dart';
import 'core/notification/inactivity_notification_service.dart';
import 'features/splash/splash_screen.dart';

class Sitr extends StatefulWidget {
  const Sitr({super.key});

  @override
  State<Sitr> createState() => _SitrState();
}

class _SitrState extends State<Sitr> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    InactivityNotificationService.scheduleInactivityReminder();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      InactivityNotificationService.scheduleInactivityReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(ScreenSizes.width, ScreenSizes.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) {
        return BlocProvider(
          create: (context) => injector<UserCubit>(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: ConstantManager.projectName,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: Go.navigatorKey,
            restorationScopeId: 'app',
            builder: (context, child) {
              return Overlay(
                initialEntries: [
                  OverlayEntry(builder: (context) => Stack(
                    children: [
                      child!,
                      ZegoUIKitPrebuiltCallMiniOverlayPage(
                          contextQuery: () => Go.context
                      ),
                    ],
                  )),
                ],
              );
            },
            // home: EnterMaleOrFemaleOrChildDataScreen.individual(
            //     scaffoldType: ScaffoldType.appScaffold,
            //     onClick: (ctx, user)async{},
            //     userType: UserGender.male
            // ),
            home: const ZegoUIKitPrebuiltCallMiniPopScope(child: SplashScreen()),
            navigatorObservers: [AppNavigationObserver()],
            // builder: (context, child) {
            //   return InternetInterceptorWidget(
            //     loadingWidget: const SplashLogo(),
            //     onChanged: (previous, current) => _manageInternetConnectivity(context, current),
            //     builder: (previous, current) {
            //       return Stack(
            //         children: [
            //           child!,
            //           if (current == InternetConnectionStatus.disconnected)
            //             const Positioned.fill(
            //               child: NoInternetWidget(),
            //             ),
            //         ],
            //       );
            //     },
            //   );
            // },
          ),
        );
      },
    );
  }

  void _manageInternetConnectivity(BuildContext context, InternetConnectionStatus state){
    switch(state){
      case InternetConnectionStatus.connected:
        MessageUtils.showSnackBar(context: context, LocaleKeys.theInternetConnectionIsRestored);
        break;
      case InternetConnectionStatus.slow:
        MessageUtils.showSnackBar(context: context, LocaleKeys.theInternetConnectionIsSlow);
        break;

      default:
        MessageUtils.showSnackBar(context: context, LocaleKeys.theInternetConnectionIsDisabled);
    }
  }
}
