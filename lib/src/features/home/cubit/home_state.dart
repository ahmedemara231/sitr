part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeStateInitial extends HomeState {}
final class ChangeBottomNavIndex extends HomeState {}
