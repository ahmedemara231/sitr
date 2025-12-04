import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'config/language/locale_keys.g.dart';
import 'config/res/config_imports.dart';
import 'core/helpers/user_type_enum.dart';
import 'core/navigation/navigator.dart';
import 'core/shared/route_observer.dart';
import 'core/shared/user_cubit/user_cubit.dart' show UserCubit;
import 'core/widgets/connectivity_interceptor/internet_supporter_widget.dart';
import 'core/widgets/custom_messages.dart';
import 'core/widgets/no_internet_widget.dart';
import 'core/widgets/splash_logo.dart';
import 'features/auth/imports.dart' show EnterMaleOrFemaleOrChildDataScreen, ScaffoldType;
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
          child: PageStorage(
            bucket: _bucket,
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

                // home: EnterMaleOrFemaleOrChildDataScreen.individual(scaffoldType: ScaffoldType.appScaffold, showConditionsAndTerms: true, onClick: (context, user)async{}, userType: UserType.male,),
                home: const SplashScreen(),
                navigatorObservers: [AppNavigationObserver()],
                builder: (context, child) {
                  return InternetInterceptorWidget(
                    loadingWidget: const SplashLogo(),
                    onChanged: (previous, current) => _manageInternetConnectivity(context, current),
                    builder: (previous, current) {
                      return Stack(
                        children: [
                          child!,
                          if (current == InternetConnectionStatus.disconnected)
                            const Positioned.fill(
                              child: NoInternetWidget(),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
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

/*
* اما يجي نوتيفيكيشن تبع الشات ايه الداتا اللي فيه؟
*
*
*
*
*
*
*
* */


final PageStorageBucket _bucket = PageStorageBucket();

// class EasyChatExample extends StatelessWidget {
//   const EasyChatExample({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Example(),
//     );
//   }
// }
//
// class Example extends StatelessWidget {
//   Example({super.key});
//
//   final PagifyController<ChatMessages> _chatController = PagifyController();
//   Future<List<ChatMessages>> testFun(int currentPage)async {
//     List<ChatMessages> msgs = [];
//     await Future.delayed(const Duration(seconds: 2));
//     msgs.addAll([
//       ChatMessages(senderImage: 'image', message: 'message1', time: 'time1', isFromMe: true),
//       ChatMessages(senderImage: 'image', message: 'message2', time: 'time1', isFromMe: true),
//       ChatMessages(senderImage: 'image', message: 'message3', time: 'time1', isFromMe: false),
//       ChatMessages(senderImage: 'image', message: 'message4', time: 'time1', isFromMe: false),
//       ChatMessages(senderImage: 'image', message: 'message5', time: 'time1', isFromMe: true),
//       ChatMessages(senderImage: 'image', message: 'message6', time: 'time1', isFromMe: false),
//     ]);
//     return msgs;
//   }
//   //
//   Widget _buildMessage(ChatMessages chatMessage) {
//     if(chatMessage.message.contains('png')){
//       return Image.network(chatMessage.message);
//     }else if(chatMessage.message.contains('pdf')){
//       // return pgf file
//       return SizedBox.shrink();
//     }else if(chatMessage.message.contains('mp4')){
//       // return video
//       return SizedBox.shrink();
//     }else if(chatMessage.message.contains('mp3')){
//       // return audio
//       return SizedBox.shrink();
//     }else{
//       return Text(chatMessage.message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: EasyChat(
//         socketType: ClientIOImpl(
//             url: 'server url',
//             roomId: 0,
//             extraHeaders: {},
//             extraParams: {},
//             events: EasyChatEvents(
//               otherEvents: [],
//               messageEvents: MessageEvents(
//                   receiveMsgEvent: 'receiveMsgEvent',
//                   sendMsgEvent: 'sendMsgEvent'
//               ),
//             ),
//             jsonToChatMessage: (jsonMessage) => ChatMessages(
//                 senderImage: jsonMessage['senderImage'],
//                 message: jsonMessage['message'],
//                 time: jsonMessage['time'],
//                 isFromMe: jsonMessage['isFromMe']
//             ),
//             onReceiveMessage: (msg){},
//             onReceiveAnyEvent: (e, d){}
//         ),
//         controller: _chatController,
//         asyncCall: (context, page) async => await testFun(page),
//         mapper: (response) => PagifyData(
//             data: response,
//             paginationData: PaginationData(
//                 perPage: 10, totalPages: 3
//             )
//         ),
//         errorMapper: PagifyErrorMapper(errorWhenDio: (e) => e.response?.data['error']),
//         rightMessageBuilder: _buildMessage,
//         leftMessageBuilder: _buildMessage,
//       ),
//       bottomNavigationBar: TextField(
//         decoration: InputDecoration(
//           suffixIcon: IconButton(onPressed: (){
//             // send any chat message,
//
//             // move to max bottom like any chat
//             _chatController.moveToMaxBottom();
//           }, icon: Icon(Icons.send)),
//         ),
//       ),
//     );
//   }
// }

