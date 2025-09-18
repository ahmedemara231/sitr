
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../more/presentation/screens/more_screen.dart';



part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeStateInitial());
  int currentIndex = 0;

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    log(currentIndex.toString());
    emit(ChangeBottomNavIndex());
  }

  List<Widget> screens =   [
    Container(),
    Container(),
    Container(),
    Container(color: Colors.red,),
    const MoreScreen(),
  ];
}
