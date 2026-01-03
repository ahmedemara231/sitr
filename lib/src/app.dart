import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'config/language/locale_keys.g.dart';
import 'config/res/config_imports.dart';
import 'core/navigation/navigator.dart';
import 'core/shared/route_observer.dart';
import 'core/shared/user_cubit/user_cubit.dart' show UserCubit;
import 'core/widgets/custom_messages.dart';
import 'features/home/cubits/get_notification_count.dart';
import 'features/splash/splash_screen.dart';

class Sitr extends StatelessWidget {
  const Sitr({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(ScreenSizes.width, ScreenSizes.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) {
        return BlocProvider(
          create: (context) => injector<UserCubit>(),
          child: BlocProvider(
            create: (context) => GetNotificationCountCubit()..startNotificationInterceptor(),
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
                    OverlayEntry(builder: (context) => child!),
                  ],
                );
              },
              home: const SplashScreen(),
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
