import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:upgrader/upgrader.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../core/helpers/helpers.dart';
import '../../core/helpers/lancher_helper.dart';
import '../../core/notification/inactivity_notification_service.dart';
import '../../core/notification/notification_service.dart';
import '../../core/shared/models/user_models/user_model.dart';
import '../../core/shared/user_cubit/user_cubit.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/icon_widget.dart';
import '../../core/widgets/promotion_reminder_dialog.dart';
import '../whats_new/whats_new_service.dart';
import 'cubits/get_notification_count.dart';
import 'cubits/home_cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  final bool showPromotionReminder;

  const HomeScreen({
    super.key,
    this.initialIndex = 0,
    this.showPromotionReminder = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _initApp() async {
    await _handleNotifications();
    await _handleTrackingPermission();
    if (UserModel.isAuthenticated) {
      await Helpers.initZegoService();
    }
    // _checkForUpdates();
  }

  Future<void> _handleNotifications() async {
    InactivityNotificationService.init();
    NotificationNavigator(
      onRoutingMessage: (message) {
        NotificationRoutes.navigateByType(message.data);
      },
      onNoInitialMessage: () {},
    );
    await injector<NotificationService>().setupNotifications();
  }

  Future<void> _checkForUpdates() async {
    bool makeAnotherCheck = true;
    final shorebirdCodePush = ShorebirdUpdater();
    while (makeAnotherCheck) {
      final status = await shorebirdCodePush.checkForUpdate();
      final isUpdateAvailable = status == UpdateStatus.outdated;
      final isRestartNeeded = status == UpdateStatus.restartRequired;

      if (isUpdateAvailable) {
        await shorebirdCodePush.update();
      } else if (isRestartNeeded) {
        Helpers.showRestartSheet();
        makeAnotherCheck = false;
      } else {
        makeAnotherCheck = false;
      }
    }
  }

  Future<void> _requestTrackingPermission() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  Future<void> _handleTrackingPermission() async {
    if (Platform.isIOS) {
      final currentStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      switch (currentStatus) {
        case TrackingStatus.notDetermined:
        case TrackingStatus.denied:
          await _requestTrackingPermission();
          break;

        default:
          break;
      }
    }
  }

  @override
  void initState() {
    _initApp();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLaunchDialogs());
    super.initState();
  }

  Future<void> _showLaunchDialogs() async {
    await WhatsNewService.showIfNeeded(upgrader: upgrader);
    if (!mounted || !widget.showPromotionReminder) return;

    await showPromotionReminderDialog();
    await UserCubit.instance.resetPromotionReminderLaunchCount();
  }

  late final upgrader = Upgrader(
    // debugDisplayAlways: kDebugMode,
    debugLogging: true,
    durationUntilAlertAgain: Duration.zero,
    storeController: UpgraderStoreController(
      onAndroid: () => UpgraderPlayStore(),
      oniOS: () => UpgraderAppStore(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    context.locale;
    return UpgradeAlert(
      upgrader: upgrader,
      shouldPopScope: () => true,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      onUpdate: () {
        if (Platform.isIOS) {
          LauncherHelper.launchURL(
              url:
                  'https://apps.apple.com/us/app/%D8%B3%D8%AA%D8%B1/id6756270317');
        } else {
          LauncherHelper.launchURL(
              url:
                  'https://play.google.com/store/apps/details?id=com.aait.flutter.sitr');
        }
        return true;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(currentIndex: widget.initialIndex),
          ),
          BlocProvider(
              create: (context) => GetNotificationCountCubit()
                ..getNotificationCount()
                ..startNotificationInterceptor()),
          BlocProvider(
              create: (context) => GetChatsNotificationCountCubit()
                ..getChatNotificationCount()
                ..startNotificationInterceptor()),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final HomeCubit cubit = context.read<HomeCubit>();
            final int tabsCount = cubit.screens.length;
            final double tabWidth =
                MediaQuery.sizeOf(context).width / tabsCount;
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
                            color: Colors.black.withValues(alpha: 0.25),
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
                            fontWeight: FontWeight.w500,
                          ),
                          currentIndex: cubit.currentIndex,
                          onTap: (index) {
                            if (index != 0 && index != tabsCount - 1) {
                              if (UserModel.isAuthenticated) {
                                cubit.changeBottomNavIndex(index);
                              } else {
                                Helpers.showUnauthenticatedSheet();
                              }
                            } else {
                              cubit.changeBottomNavIndex(index);
                            }

                            if (index == 1) {
                              context.read<GetNotificationCountCubit>().reset();
                            } else if (index == 2) {
                              context
                                  .read<GetChatsNotificationCountCubit>()
                                  .reset();
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
                              icon: BlocBuilder<GetNotificationCountCubit,
                                  AsyncState<int>>(
                                builder: (context, state) => Badge(
                                  backgroundColor: AppColors.primary,
                                  label: AppText(state.data.toString()),
                                  isLabelVisible:
                                      state.data <= 0 ? false : true,
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
                              icon: BlocBuilder<GetChatsNotificationCountCubit,
                                  AsyncState<int>>(
                                builder: (context, state) => Badge(
                                  backgroundColor: AppColors.primary,
                                  label: AppText(state.data.toString()),
                                  isLabelVisible:
                                      state.data <= 0 ? false : true,
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
                                icon: Icons.person_add_alt_1_outlined,
                                color: cubit.currentIndex == 3
                                    ? AppColors.primary
                                    : AppColors.unSelectedLabelColor,
                              ),
                              label: LocaleKeys.requests,
                            ),
                            BottomNavigationBarItem(
                              icon: IconWidget(
                                icon: Assets.svgPackageIcon,
                                color: cubit.currentIndex == 4
                                    ? AppColors.primary
                                    : null,
                              ),
                              label: LocaleKeys.packages,
                            ),
                            BottomNavigationBarItem(
                              icon: IconWidget(
                                icon: Assets.svgMoreIcon,
                                color: cubit.currentIndex == 5
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
                      start: (tabWidth * cubit.currentIndex) + 7.5.w,
                      child: Container(
                        width: tabWidth - 15.w,
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
      ),
    );
  }
}
