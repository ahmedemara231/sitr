import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';


abstract class ChatNotificationService{
  Stream<RemoteMessage> get notificationStream;
  void init();
}

class ChatNotificationServiceImpl implements ChatNotificationService{
  final StreamController<RemoteMessage> notificationController = StreamController<RemoteMessage>.broadcast();

  @override
  Stream<RemoteMessage> get notificationStream => notificationController.stream;

  @override
  void init() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationController.add(message);
    });
  }
}