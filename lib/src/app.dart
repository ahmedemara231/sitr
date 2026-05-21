import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'config/res/config_imports.dart';
import 'core/navigation/navigator.dart';
import 'core/shared/route_observer.dart';
import 'core/shared/user_cubit/user_cubit.dart' show UserCubit;
import 'core/notification/inactivity_notification_service.dart';
import 'features/auth/imports.dart';
import 'features/more/presentation/screens/contact_us/contact_us_chat_screen.dart';
import 'features/on_boarding/screen.dart';
import 'features/settings/splash/screens/splash_screen.dart';
import 'features/splash/splash_screen.dart';

class Satr extends StatefulWidget {
  const Satr({super.key});

  @override
  State<Satr> createState() => _SatrState();
}

class _SatrState extends State<Satr> with WidgetsBindingObserver {
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
            // home: const ContactUsChatScreen(),
            home: const ZegoUIKitPrebuiltCallMiniPopScope(child: SplashScreen()),
            navigatorObservers: [AppNavigationObserver.instance],
          ),
        );
      },
    );
  }
}
