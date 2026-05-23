import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/auth/imports.dart';
import '../../features/chats/data/models/chat_model.dart';
import '../../features/chats/data/models/message_params_model.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/data/socket_events.dart';
import '../../features/chats/enums.dart';
import '../../features/chats/presentation/cubits/get_chats_cubit.dart';
import '../../features/chats/presentation/imports.dart';
import '../../features/chats/presentation/screens/previous_chat_screen.dart';
import '../../features/main_screen/presentation/screens/parent_details.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../../features/more/presentation/screens/complaint_and_suggestion/complaint_details_screen.dart';
import '../../features/more/presentation/screens/contact_us/contact_us_chat_screen.dart';
import '../../features/more/presentation/screens/my_packages.dart';
import '../../features/more/presentation/screens/profile.dart';
import '../../features/more/presentation/screens/wallet/wallet_screen.dart';
import '../extensions/object.dart';
import '../extensions/string_extension.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../network/api_endpoints.dart';
import '../network/network_request.dart';
import '../network/network_service.dart';
import '../shared/user_cubit/user_cubit.dart';
import '../socket_service/client_io.dart';
import '../widgets/parent_children_screen.dart';

part 'navigation_types.dart';
part 'notification_routes.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('========= >>> backGroundMessage ${message.data}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  log('Background notification action: ${response.actionId}');
  handleNotificationAction(response);
}

Future<void> _emitUpdateChatEvent({
  required int roomId,
  required int matchRequestId,
  required int receiverId,
}) async {
  final completer = Completer<void>();
  late final SocketHelper socket;
  socket = ClientIOImpl(
    onConnect: (d) {
      log('notification action socket connected');
      socket.emitEvent(
        event: SocketEvents.updateChat,
        data: {
          'room_id': roomId,
          'match_request_id': matchRequestId,
          'receiver_id': receiverId,
        },
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        socket.disconnect();
        if (!completer.isCompleted) completer.complete();
      });
    },
    onDisconnect: (d) => log('notification action socket disconnected'),
    extraParams: MessageParamsModel().toJson(),
    url: ConstantManager.socketUrl,
    roomId: 0,
    jsonToChatMessage: (_) => throw UnimplementedError(),
    onReceiveMessage: (_) {},
    events: EasyChatEvents(
      messageEvents: MessageEvents(
        receiveMsgEvent: SocketEvents.receivedMsg,
        sendMsgEvent: SocketEvents.sendMsg,
      ),
      chatEvents: ChatEvents(
        enterChatEvent: SocketEvents.enterChat,
        exitChatEvent: SocketEvents.exitChat,
      ),
      otherEvents: [],
    ),
  )..initSocket()..initConfig()..connect();

  // Wait for emit + disconnect, with a timeout so we don't hang forever
  await completer.future.timeout(
    const Duration(seconds: 5),
    onTimeout: () {
      log('notification action socket timed out');
      try { socket.disconnect(); } catch (_) {}
    },
  );
}

Future<void> handleNotificationAction(NotificationResponse? payload) async {
  log('handleNotificationAction called with actionId: ${payload?.actionId}');
  if (payload?.actionId == null || payload!.actionId!.isEmpty) {
    log('handleNotificationAction: actionId is null or empty, returning');
    return;
  }

  final decodedPayload = json.decode(payload.payload ?? '{}');
  log('handleNotificationAction decoded payload: $decodedPayload');

  final messageData = (decodedPayload['data'] as Map<String, dynamic>?) ?? (decodedPayload as Map<String, dynamic>?);
  log('handleNotificationAction decodedPayload keys: ${decodedPayload.keys}');
  log('handleNotificationAction messageData: $messageData');
  if (messageData == null) {
    log('handleNotificationAction: messageData is null, returning');
    return;
  }

  final userRequest = messageData['user_request'] as String?;
  final matchRequestId =
      (messageData['match_request_id'] ?? messageData['match_request'])
          ?.toString();
  final senderId =
      (messageData['sender'] ?? messageData['user_id'] ?? messageData['sender_id'])
          ?.toString();
  log('handleNotificationAction: userRequest=$userRequest');
  log('handleNotificationAction: matchRequestId=$matchRequestId');
  log('handleNotificationAction: senderId=$senderId');
  if (userRequest == null || matchRequestId == null || senderId == null) {
    log('handleNotificationAction: missing required fields → userRequest=$userRequest, matchRequestId=$matchRequestId, senderId=$senderId');
    return;
  }

  final String path;
  if (payload.actionId == NotificationService.acceptChat) {
    path = ApiConstants.acceptRequest + userRequest;
  } else if (payload.actionId == NotificationService.rejectChat) {
    path = ApiConstants.rejectRequest + userRequest;
  } else {
    log('handleNotificationAction: unknown actionId ${payload.actionId}, returning');
    return;
  }

  log('handleNotificationAction: calling API with path=$path');
  try {
    final networkService = injector<NetworkService>();
    final response = await networkService.callApi<ChatModel>(
      NetworkRequest(
        path: path,
        method: RequestMethod.post,
        body: {
          'receiver_id': senderId,
          'from_home': '0',
          'match_request_id': matchRequestId,
        },
      ),
      mapper: (json) => ChatModel.fromJson(json),
    );
    log('handleNotificationAction: API call succeeded');

    final roomId = response.data.room?.id ?? 0;
    final responseMatchRequestId = response.data.matchRequest?.id ?? 0;
    final receiverId = int.tryParse(senderId) ?? 0;
    await _emitUpdateChatEvent(
      roomId: roomId,
      matchRequestId: responseMatchRequestId,
      receiverId: receiverId,
    );
  } catch (e) {
    log('handleNotificationAction: API call failed with error: $e');
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  static String deviceToken = '1234';

  Future<bool> _requestPermissions() async {
    bool? result;
    if (Platform.isIOS) {
      result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else {
      result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _createAndroidChannel();
    }
    return result ?? false;
  }

  Future<void> _createAndroidChannel() async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static final String acceptChat = 'accept_chat';
  static final String rejectChat = 'reject_chat';
  static const String _chatActionsCategoryId = 'chat_actions_category';

  void _showNotification(RemoteMessage message) async {
    log('the remote msg is ${message.data}');
    log('the remote msg is ${message.notification?.toMap()}');
    final bool hasActions = _shouldShowActions(message);
    final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: hasActions ? _chatActionsCategoryId : '',
        );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: ConstantManager.appName,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      importance: Importance.high,
      priority: Priority.max,
      actions: _getActions(message),
    );
    final notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );
    final notification = message.notification;
    await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title ?? '',
        notification?.body,
        notificationDetails,
        payload: json.encode(message.toMap())
    );
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          _chatActionsCategoryId,
          actions: [
            DarwinNotificationAction.plain(
              acceptChat,
              LocaleKeys.accept,
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              rejectChat,
              LocaleKeys.refused,
              options: {
                DarwinNotificationActionOption.destructive,
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
        ),
      ],
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse? payload) {
          final bool isActionButton =
              payload?.actionId != null && payload!.actionId!.isNotEmpty;
          _handleActions(payload);
          if (!isActionButton) {
            _handleNotificationsTap(
                RemoteMessage.fromMap(json.decode(payload!.payload ?? '')));
          }
        },
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  (UserRequestStatus, ChatStages) _getChatData(RemoteMessage message){
    final UserRequestStatus status = ((message.data['user_request_status'] ?? '') as String).getUserRequestStatusAsEnum;
    final ChatStages stage = ((message.data['stage'] ?? '') as String).getCurrentStageAsStagesEnum;
    return (status, stage);
  }

  bool _convertToActionsData(RemoteMessage message){
    final data = _getChatData(message);
    return data.isNotNull;
  }

  bool _shouldShowActions(RemoteMessage message) {
    try {
      return _convertToActionsData(message);

    } on Exception {
      return false;
    }
  }

  List<AndroidNotificationAction> _tryingToMakeActions(RemoteMessage message){
    final data = _getChatData(message);
    log('the data is ${data.$2}');
    log('the data is ${data.$1}');
    log('the data is ${data.$2.isNewChat && data.$1.isPending}');
    if(data.$2.isNewChat && data.$1.isPending){
      return [
        AndroidNotificationAction(
          acceptChat,
          LocaleKeys.accept,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          rejectChat,
          LocaleKeys.refused,
          showsUserInterface: true,
        ),
      ];

    }else{
      return [];
    }
  }
  List<AndroidNotificationAction> _getActions(RemoteMessage message){
    try {
      return _tryingToMakeActions(message);
    } on Exception{
      return [];
    }
  }

  Future<void> _handleActions(NotificationResponse? payload) async {
    await handleNotificationAction(payload);
  }

  Future<void> _registerNotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _handleNotificationsTap(RemoteMessage? message) async {
    if (message == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationNavigator._instance?.onRoutingMessage(message);
    });
  }

  Future<void> saveFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      deviceToken = token ?? '1234';
      log('Firebase Fcm token : ${token.toString()}');
    } on Exception {
      return;
    }
  }

  Future<void> _setForegroundNotificationOptions() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  bool _isInitialized = false;

  Future<void> setupNotifications() async {
    if (_isInitialized) return;
    _isInitialized = true;
    // Register early — before any awaits — so onMessageOpenedApp events
    // fired during async initialization are never missed.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      _handleNotificationsTap(event);
    });
    await Future.wait([
      _setForegroundNotificationOptions(),
      _registerNotification(),
      _requestPermissions(),
      NotificationNavigator._instance!.init(),
    ]);
    await _initLocalNotification();
    _configureNotification();
  }

  void _configureNotification() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _showNotification(event);
      final type = (event.data['type'] as String).getType;
      if(type.isAccountDeletedByAdmin || type.isBlock
          // type.isParentIndividualApprovalRejected ||
          // type.isMatchRejectedWhenTimerEnded
      ){
        NotificationRoutes.navigateByType(event.data);
      }
    });
  }

}

class NotificationNavigator {
  NotificationNavigator._({
    required this.onRoutingMessage,
    required this.onNoInitialMessage,
  });

  static NotificationNavigator? _instance;
  RemoteMessage? _message;

  factory NotificationNavigator({
    required void Function(RemoteMessage message) onRoutingMessage,
    required void Function() onNoInitialMessage,
  }) {
    return _instance ??= NotificationNavigator._(
      onRoutingMessage: onRoutingMessage,
      onNoInitialMessage: onNoInitialMessage,
    );
  }

  Future<void> init() async {
    _message = await FirebaseMessaging.instance.getInitialMessage();
    if (_message != null) {
      onRoutingMessage(_message!);
    } else {
      onNoInitialMessage();
    }
  }

  final void Function(RemoteMessage message) onRoutingMessage;
  final void Function() onNoInitialMessage;
}
