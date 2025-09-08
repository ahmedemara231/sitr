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
import 'features/auth/presentation/screens/enter_male_female_child_data.dart';
import 'features/auth/presentation/screens/login.dart';
import 'features/more/presentation/screens/edit_profile.dart';
import 'features/more/presentation/screens/profile.dart';
import 'features/otp/presentation/otp.dart';
import 'features/auth/presentation/screens/sign_up.dart';
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
            home: const SplashScreen(),
            // home: const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner(type: UserType.female),
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


// class PathProviderTest extends StatelessWidget {
//   const PathProviderTest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: TextButton(
//             onPressed: () async{
//               final path = await getApplicationDocumentsDirectory();
//               log('Directory path: ${path.path}');
//
//               final filePath = join(path.path, 'counter2.txt');
//               log('Full file path: $filePath');
//
//               final file = File(filePath);
//               await file.writeAsString('counter : 1');
//               log('File written successfully');
//             },
//             child: const AppText('get path', fontSize: 60,)
//         ),
//       ),
//     );
//   }
// }
//
//
// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LlmChatView(
//         style: LlmChatViewStyle.defaultStyle(),
//         // suggestions: [],
//         // speechToText: ,
//
//         //     Stream<String> Function(
//         //     String prompt, {
//         //   required Iterable<Attachment> attachments,
//         // });
//         //   messageSender: (prompt, {attachments}) => ,
//         enableVoiceNotes: true,
//         enableAttachments: true,
//         responseBuilder: (context, msg) => AppText(msg, color: Colors.amber, fontSize: 16.sp),
//         errorMessage: '',
//         welcomeMessage: 'hola',
//         onCancelCallback: (context) {},
//         onErrorCallback: (context, e) => log('e is ${e.toString()}'),
//         provider: FirebaseProvider( // use FirebaseProvider and googleAI()
//           model: FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash'),
//         ),
//       ),
//     );
//   }
// }
