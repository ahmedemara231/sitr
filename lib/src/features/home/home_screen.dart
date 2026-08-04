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
import '../whats_new/whats_new_service.dart';
import '../whats_new/widgets/upgrader_dialog.dart';
import 'cubits/app_badge_counts_cubit.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'data/models/app_badge_counts_model.dart';
import 'widgets/premium_upgrade_card_dialog.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLaunchDialogs());
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
    super.initState();
  }

  Future<void> _showLaunchDialogs() async {
    if (widget.showPromotionReminder){
      await showPremiumUpgradeCardDialog();
      await UserCubit.instance.resetPromotionReminderLaunchCount();
    }

    await WhatsNewService.showIfNeeded(upgrader: upgrader);
  }

  late final upgrader = Upgrader(
    debugDisplayAlways: true,
    minAppVersion: RemoteConfigValues.minAppVersion.isEmpty ?
    null : RemoteConfigValues.minAppVersion,
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
    return AppUpgradeAlert(
      upgrader: upgrader,
      onUpdatePressed: () async {
        if (Platform.isIOS) {
          await LauncherHelper.launchURL(
              url:
                  'https://apps.apple.com/us/app/%D8%B3%D8%AA%D8%B1/id6756270317');
        } else {
          await LauncherHelper.launchURL(
              url:
                  'https://play.google.com/store/apps/details?id=com.aait.flutter.sitr');
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(currentIndex: widget.initialIndex),
          ),
          BlocProvider(
            create: (context) => AppBadgeCountsCubit()
              ..loadCounts()
              ..startNotificationInterceptor(),
          ),
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
                              context
                                  .read<AppBadgeCountsCubit>()
                                  .clearNotificationsCount();
                            } else if (index == 2) {
                              context
                                  .read<AppBadgeCountsCubit>()
                                  .clearUnreadMessagesCount();
                            } else if (index == 3) {
                              context
                                  .read<AppBadgeCountsCubit>()
                                  .clearUnreadMessageRequestsCount();
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
                              icon: _AppBadgeIcon(
                                countSelector: (counts) =>
                                    counts.notificationsCount,
                                child: IconWidget(
                                  icon: Assets.svgNotificationIcon,
                                  color: cubit.currentIndex == 1
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                              label: LocaleKeys.notifications,
                            ),
                            BottomNavigationBarItem(
                              icon: _AppBadgeIcon(
                                countSelector: (counts) =>
                                    counts.unreadMessagesCount,
                                child: IconWidget(
                                  icon: Assets.svgChatsIcon,
                                  color: cubit.currentIndex == 2
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                              label: LocaleKeys.chats,
                            ),
                            BottomNavigationBarItem(
                              icon: _AppBadgeIcon(
                                countSelector: (counts) =>
                                    counts.messageRequestsCount,
                                child: IconWidget(
                                  icon: cubit.currentIndex == 3
                                      ? Icons.people_alt_rounded
                                      : Icons.people_alt_outlined,
                                  color: cubit.currentIndex == 3
                                      ? AppColors.primary
                                      : AppColors.unSelectedLabelColor,
                                ),
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

class _AppBadgeIcon extends StatelessWidget {
  final int Function(AppBadgeCountsModel counts) countSelector;
  final Widget child;

  const _AppBadgeIcon({
    required this.countSelector,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBadgeCountsCubit, AsyncState<AppBadgeCountsModel>, int>(
      selector: (state) => countSelector(state.data),
      builder: (context, count) => Badge(
        backgroundColor: AppColors.primary,
        label: AppText(count.toString()),
        isLabelVisible: count > 0,
        child: child,
      ),
    );
  }
}
