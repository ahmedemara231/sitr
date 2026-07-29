import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../chats/presentation/screens/chats_screen.dart';
import '../../../connection_requests/presentation/screens/connection_requests_screen.dart';
import '../../../main_screen/presentation/screens/view.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../../../notifications/presentation/pages/noitifcations_screen.dart';
import '../../../packages/presentation/packages_screen.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  int currentIndex;

  HomeCubit({this.currentIndex = 0}) : super(HomeStateInitial());
  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavIndex());
  }

  final List<Widget> screens = const [
    MainView(),
    NotificationsScreen(),
    ChatsScreen(),
    ConnectionRequestsScreen(),
    PackagesScreen.subscription(),
    MoreScreen(),
  ];
}
