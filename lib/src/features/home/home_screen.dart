import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../core/helpers/helpers.dart';
import '../../core/notification/inactivity_notification_service.dart';
import '../../core/notification/notification_service.dart'; // NotificationNavigator, NotificationRoutes
import '../../core/shared/models/user_models/user_model.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/icon_widget.dart';
import 'cubits/get_notification_count.dart';
import 'cubits/home_cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _initApp() async {
    InactivityNotificationService.init();
    NotificationNavigator(
      onRoutingMessage: (message) {
        NotificationRoutes.navigateByType(message.data);
      },
      onNoInitialMessage: () {},
    );
    await injector<NotificationService>().setupNotifications();
  }

  void _initZego()async{
    await Helpers.initZegoService(
        onCallStarted: (){
          // if(EndVideoCallCubit.instance.state.data.matchRequest?.callStatus == 'free_available'){
          //   log('end video call');
          //   EndVideoCallCubit.instance.endVideoCall( // برنها وانا فالكول
          //       ChatsData.data!.matchRequest!.id.toString()
          //   );
          // }
        },
        onCallEnd: (event, defaultAction) {
          log('Call ended with reason: ${event.reason}');

          // Handle different call end reasons
          // switch (event.reason) {
          //   case ZegoCallEndReason.localHangUp:
          //     log('Local user hung up');
          //     break;
          //   case ZegoCallEndReason.remoteHangUp:
          //     log('Remote user hung up');
          //     break;
          //   case ZegoCallEndReason.kickOut:
          //     log('User was kicked out by: ${event.kickerUserID}');
          //     break;
          // }

          // Call the default action to return to previous page
          defaultAction();
        }
    );
  }

  @override
  void initState() {
    _initApp();
    _initZego();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => GetNotificationCountCubit()..getNotificationCount()..startNotificationInterceptor()),
        BlocProvider(create: (context) => GetChatsNotificationCountCubit()..getChatNotificationCount()..startNotificationInterceptor()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            backgroundColor: AppColors.whiteScaffoldBackground,
            body: SafeArea(child: cubit.screens[cubit.currentIndex]),
            bottomNavigationBar: PopScope(
              onPopInvokedWithResult: (bool didPop, dynamic result) {
                if (cubit.currentIndex != 0) {
                  cubit.changeBottomNavIndex(0);
                }
              },
              canPop: false,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 80.h,
                      child: BottomNavigationBar(
                        backgroundColor: Colors.white,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: AppColors.primary,
                        unselectedItemColor: AppColors.unSelectedLabelColor,
                        selectedLabelStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,),
                        currentIndex: cubit.currentIndex,
                        onTap: (index) {
                          if(index != 0 && index != 4){
                            if(UserModel.isAuthenticated){
                              cubit.changeBottomNavIndex(index);

                            }else{
                              Helpers.showUnauthenticatedSheet();
                            }
                          }else{
                            cubit.changeBottomNavIndex(index);
                          }

                          if(index == 1){
                            context.read<GetNotificationCountCubit>().reset();

                          }else if(index == 2){
                            context.read<GetChatsNotificationCountCubit>().reset();
                          }

                          return;
                        },
                        items: [
                          BottomNavigationBarItem(
                            icon: IconWidget(
                              icon: Assets.svgHomeIcon,
                              color: cubit.currentIndex == 0
                                  ? AppColors.primary
                                  : null,
                            ),
                            label: LocaleKeys.home,
                          ),
                          BottomNavigationBarItem(
                            icon: BlocBuilder<GetNotificationCountCubit, AsyncState<int>>(
                              builder: (context, state) => Badge(
                                backgroundColor: AppColors.primary,
                                label: AppText(state.data.toString()),
                                isLabelVisible: state.data <= 0 ? false : true,
                                child: IconWidget(
                                  icon: Assets.svgNotificationIcon,
                                  color: cubit.currentIndex == 1
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                            ),
                            label: LocaleKeys.notifications,
                          ),
                          BottomNavigationBarItem(
                            icon: BlocBuilder<GetChatsNotificationCountCubit, AsyncState<int>>(
                              builder: (context, state) => Badge(
                                backgroundColor: AppColors.primary,
                                label: AppText(state.data.toString()),
                                isLabelVisible: state.data <= 0 ? false : true,
                                child: IconWidget(
                                  icon: Assets.svgChatsIcon,
                                  color: cubit.currentIndex == 2
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                            ),
                            label: LocaleKeys.chats,
                          ),
                          BottomNavigationBarItem(
                            icon: IconWidget(
                              icon: Assets.svgPackageIcon,
                              color: cubit.currentIndex == 3
                                  ? AppColors.primary
                                  : null,
                            ),
                            label: LocaleKeys.packages,
                          ),
                          BottomNavigationBarItem(
                            icon: IconWidget(
                              icon: Assets.svgMoreIcon,
                              color: cubit.currentIndex == 4
                                  ? AppColors.primary
                                  : null,
                            ),
                            label: LocaleKeys.more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: (cubit.currentIndex == 0
                        ? 10.w
                        : cubit.currentIndex == 1
                            ? 80.w
                            : cubit.currentIndex == 2
                                ? 152.w
                                : cubit.currentIndex == 3
                                    ? 228.w
                                    : 298.w),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 5) - 15.w,
                      height: 3.w,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
