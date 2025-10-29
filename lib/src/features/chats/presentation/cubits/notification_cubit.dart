import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notification/notification_service.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/chat_notification_service.dart';

class ChatNotificationCubit extends Cubit<ChatNotificationState> {
  final ChatNotificationService _notificationService;
  late final StreamSubscription _sub;

  ChatNotificationCubit(this._notificationService) : super(ChatNotificationState.initial()) {
    _notificationService.init();
    _sub = _notificationService.notificationStream.listen(_onNotification);
  }

  void _onNotification(RemoteMessage notification) {
    emit(state.copyWith(notification: notification));
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}


final class ChatNotificationState extends Equatable {
  final RemoteMessage? notification;
  final BaseStatus baseStatus;
  final String errorMessage;

  const ChatNotificationState({
    required this.baseStatus,
    this.errorMessage = '',
    this.notification,
  });

  NotificationType get notificationType =>
      (notification?.data['type'] as String).getType;

  factory ChatNotificationState.initial() => const ChatNotificationState(
    baseStatus: BaseStatus.initial,
    notification: null,
  );

  ChatNotificationState copyWith({
    BaseStatus? baseStatus,
    String? errorMessage,
    RemoteMessage? notification,
  }) =>  ChatNotificationState(
    baseStatus: baseStatus ?? this.baseStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    notification: notification ?? this.notification,
  );

  @override
  List<Object?> get props => [
    baseStatus,
    errorMessage,
    notification,
  ];
}