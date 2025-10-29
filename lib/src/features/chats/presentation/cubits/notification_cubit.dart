import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/chat_notification_service.dart';

class ChatNotificationCubit extends Cubit<NotificationState> {
  final ChatNotificationService _notificationService;
  late final StreamSubscription _sub;

  ChatNotificationCubit(this._notificationService) : super(NotificationInitial()) {
    _sub = _notificationService.notificationStream.listen(_onNotification);
  }

  void _onNotification(RemoteMessage notification) {
    emit(NotificationReceived(notification));
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

sealed class NotificationState {}
class NotificationInitial extends NotificationState {}
class NotificationReceived extends NotificationState {
  final RemoteMessage notification;
  NotificationReceived(this.notification);
}