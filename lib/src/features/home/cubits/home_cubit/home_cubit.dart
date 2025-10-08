import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main_screen/presentation/screens/view.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../../../notifications/presentation/pages/noitifcations_screen.dart';
import '../../../packages/presentation/packages_screen.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeStateInitial());
  int currentIndex = 0;

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    log(currentIndex.toString());
    emit(ChangeBottomNavIndex());
  }

  List<Widget> screens = [
    MainView(),
    const NotificationsScreen(),
    Container(),
    const PackagesScreen.view(),
    const MoreScreen(),
  ];

}
