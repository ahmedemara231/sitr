import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/network/network_service.dart';
import '../../core/widgets/icon_widget.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    injector<NetworkService>().setToken('Bearer 163|HHo3wbY3XYokTkKKl8AdDxHFzgjbKzsiVDYL0EOl');
    return BlocProvider(
      create: (context) => HomeCubit(),
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
                    child: BottomNavigationBar(
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
                      onTap: (index) => cubit.changeBottomNavIndex(index),
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
                          icon: IconWidget(
                            icon: Assets.svgNotificationIcon,
                            color: cubit.currentIndex == 1
                                ? AppColors.primary
                                : null,
                          ),
                          label: LocaleKeys.notifications,
                        ),
                        BottomNavigationBarItem(
                          icon: IconWidget(
                            icon: Assets.svgChatsIcon,
                            color: cubit.currentIndex == 2
                                ? AppColors.primary
                                : null,
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
