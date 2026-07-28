import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../helpers/apps_flyer/apps_flyer_helper.dart';
import '../../features/auth/imports.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/presentation/cubits/get_chats_cubit.dart';
import '../../features/chats/presentation/imports.dart';
import '../../features/chats/presentation/screens/previous_chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/main_screen/presentation/screens/parent_details.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../../features/more/presentation/screens/complaint_and_suggestion/complaint_details_screen.dart';
import '../../features/more/presentation/screens/contact_us/contact_us_chat_screen.dart';
import '../../features/more/presentation/screens/my_packages.dart';
import '../../features/more/presentation/screens/profile.dart';
import '../../features/more/presentation/screens/wallet/wallet_screen.dart';
import '../extensions/string_extension.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../network/api_endpoints.dart';
import '../network/network_request.dart';
import '../network/network_service.dart';
import '../shared/user_cubit/user_cubit.dart';
import '../widgets/parent_children_screen.dart';

part 'navigation_types.dart';
part 'notification_routes.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('========= >>> backGroundMessage ${message.data}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  log('Background notification action: ${response.actionId}');
  handleNotificationAction(response);
}

Future<void> handleNotificationAction(NotificationResponse? payload) async {
  log('handleNotificationAction called with actionId: ${payload?.actionId}');
  if (payload?.actionId == null || payload!.actionId!.isEmpty) {
    log('handleNotificationAction: actionId is null or empty, returning');
    return;
  }

  final decodedPayload = json.decode(payload.payload ?? '{}');
  log('handleNotificationAction decoded payload: $decodedPayload');

  final messageData = (decodedPayload['data'] as Map<String, dynamic>?) ??
      (decodedPayload as Map<String, dynamic>?);
  log('handleNotificationAction decodedPayload keys: ${decodedPayload.keys}');
  log('handleNotificationAction messageData: $messageData');
  if (messageData == null) {
    log('handleNotificationAction: messageData is null, returning');
    return;
  }

  final String? messageRequestId =
      messageData['message_request_id']?.toString();
  final senderId = (messageData['sender'] ??
          messageData['user_id'] ??
          messageData['sender_id'])
      ?.toString();
  log('handleNotificationAction: messageRequestId=$messageRequestId');
  log('handleNotificationAction: senderId=$senderId');
  if (messageRequestId == null || senderId == null) {
    log(
      'handleNotificationAction: missing required message request fields',
    );
    return;
  }

  final String path;
  if (payload.actionId == NotificationService.acceptChat) {
    path = ApiConstants.acceptMessageRequest;
  } else if (payload.actionId == NotificationService.rejectChat) {
    path = ApiConstants.rejectMessageRequest;
  } else {
    log('handleNotificationAction: unknown actionId ${payload.actionId}, returning');
    return;
  }

  log('handleNotificationAction: calling API with path=$path');
  try {
    final networkService = injector<NetworkService>();
    await networkService.callApi<bool>(
      NetworkRequest(
        path: path,
        method: RequestMethod.post,
        body: {
          'message_request_id': messageRequestId,
          'sender_id': senderId,
        },
      ),
      mapper: (_) => true,
    );
    log('handleNotificationAction: API call succeeded');
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
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: hasActions ? _chatActionsCategoryId : '',
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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
        iOS: iOSPlatformChannelSpecifics);
    final notification = message.notification;
    await _flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification?.title ?? '', notification?.body, notificationDetails,
        payload: json.encode(message.toMap()));
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
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) {
        final bool isActionButton =
            payload?.actionId != null && payload!.actionId!.isNotEmpty;
        _handleActions(payload);
        if (!isActionButton) {
          _handleNotificationsTap(
              RemoteMessage.fromMap(json.decode(payload!.payload ?? '')));
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  bool _shouldShowActions(RemoteMessage message) {
    final String? requestId = message.data['message_request_id']?.toString();
    final String status =
        message.data['message_request_status']?.toString() ?? 'pending';
    return requestId != null && status == 'pending';
  }

  List<AndroidNotificationAction> _getActions(RemoteMessage message) {
    if (!_shouldShowActions(message)) return [];
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
      await AppyFlyerHelper.enableUninstallMeasurement();
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
      if (type.isAccountDeletedByAdmin || type.isBlock
          // type.isParentIndividualApprovalRejected ||
          // type.isMatchRejectedWhenTimerEnded
          ) {
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
