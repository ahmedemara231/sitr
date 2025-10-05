import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'config/res/config_imports.dart';
import 'config/themes/app_theme.dart';
import 'core/helpers/loading_manager.dart';
import 'core/helpers/user_type_enum.dart';
import 'core/navigation/navigator.dart';
import 'core/shared/route_observer.dart';
import 'core/shared/user_cubit/user_cubit.dart' show UserCubit;
import 'core/widgets/app_text.dart';
import 'core/widgets/offline_widget.dart';
import 'features/auth/imports.dart';
import 'features/home/home_screen.dart';
import 'features/more/presentation/cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import 'features/more/presentation/screens/blocked_user_screen/blocked_user_screen.dart';
import 'features/more/presentation/screens/complaint_and_suggestion/complaints_and_suggestions_screen.dart' show ComplaintsAndSuggestionsScreen;
import 'features/more/presentation/screens/consultant/consultant_screen.dart';
import 'features/more/presentation/screens/contact_us/contact_us_screen.dart';
import 'features/more/presentation/screens/edit_profile.dart';
import 'features/more/presentation/screens/more_screen.dart';
import 'features/more/presentation/screens/profile.dart';
import 'features/more/presentation/screens/success_partners/success_partners_screen.dart';
import 'features/more/presentation/screens/terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';
import 'features/more/presentation/screens/wallet/wallet_screen.dart';
import 'features/on_boarding/screen.dart';
import 'features/otp/presentation/otp.dart';
import 'features/packages/presentation/packages_screen.dart';
import 'features/settings/splash/imports/view_imports.dart';
import 'features/splash/splash_screen.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

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
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: ConstantManager.projectName,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: Go.navigatorKey,
            restorationScopeId: 'app',
            home: const HomeScreen(),
            // home: const SplashScreen(),
            // home: const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner(type: UserType.female),
            // home: const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent(),
            // home: const PackagesScreen.view(),
            // home: OtpScreen(title: '', onConfirmCode: (BuildContext context, String code) {  }, onResendCodePress: (BuildContext context) {  },),
            navigatorObservers: [AppNavigationObserver()],
            builder: (context, child) {
              return OfflineWidget(
                child: FullScreenLoadingManager(child: child!),
              );
            },
          ),
        );
      },
    );
  }
}
