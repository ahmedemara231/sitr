import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../extensions/num.dart';
import '../extensions/object.dart';

class ZegoService {
  final int appId;
  final String appSign;
  final GlobalKey<NavigatorState> navigatorKey;

  ZegoService({
    required this.appId,
    required this.appSign,
    required this.navigatorKey,
  });

  static ValueNotifier<bool> isConnected = ValueNotifier(false);
  Future<void> initZego() async {
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    await ZegoUIKit().initLog();
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
  }

  Future<bool> onUserLogin({
    required String currentUserId,
    required String currentUserName,
    Duration? callDuration,
    bool isSmallViewDraggable = true,
    bool switchLargeOrSmallViewByClick = true,
    void Function(ZegoCallEndEvent, void Function())? onCallEnd,
    void Function()? onCallStarted,
    Future<bool> Function(ZegoCallHangUpConfirmationEvent, Future<bool> Function())?
    onHangUpConfirmation,
    dynamic Function(ZegoUIKitError)? onError,
    bool addChatButton = false,
    dynamic Function()? onIncomingCallAcceptButtonPressed,
    dynamic Function()? onIncomingCallDeclineButtonPressed,
    dynamic Function(String, ZegoCallUser, String)? onIncomingCallCanceled,
    dynamic Function(String, ZegoCallUser, ZegoCallInvitationType, List<ZegoCallUser>, String)?
    onIncomingCallReceived,
    Future<void> Function(
        String, ZegoCallUser, ZegoCallInvitationType, List<ZegoCallUser>, String, Future<void> Function())?
    onIncomingMissedCallClicked,
    dynamic Function()? onIncomingMissedCallDialBackFailed,
  }) async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appId,
        appSign: appSign,
        userID: currentUserId,
        userName: currentUserName,
        // uiConfig: ZegoCallInvitationUIConfig(
        //   inviter: ZegoCallInvitationInviterUIConfig(
        //     showAvatar: true,
        //     showCentralName: true,
        //     showCallingText: true,
        //   ),
        //   // Invitee (receiver) UI settings
        //   invitee: ZegoCallInvitationInviteeUIConfig(
        //     showAvatar: true,
        //     showCentralName: true,
        //     showCallingText: true,
        //   ),
        //
        //   // inviter: ZegoCallInvitationInviterUIConfig(
        //   //   backgroundBuilder: (
        //   //       BuildContext context,
        //   //       Size size,
        //   //       ZegoCallingBuilderInfo info,
        //   //       ) {
        //   //     return Container();
        //   //   },
        //   // ),
        //   // invitee: ZegoCallInvitationInviteeUIConfig(
        //   //   backgroundBuilder: (
        //   //       BuildContext context,
        //   //       Size size,
        //   //       ZegoCallingBuilderInfo info,
        //   //       ) {
        //   //     return Container(
        //   //       width: size.width,
        //   //       height: size.height,
        //   //       decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
        //   //       child: Center(
        //   //         child: Text(
        //   //           'inviter:${info.inviter.name}, invitees:${info.invitees.map((e) => '${e.name},')}',
        //   //           style: const TextStyle(
        //   //             color: Colors.white,
        //   //             fontSize: 12,
        //   //             decoration: TextDecoration.none,
        //   //           ),
        //   //         ),
        //   //       ),
        //   //     );
        //   //   },
        //   // ),
        // ),
        notificationConfig: ZegoCallInvitationNotificationConfig(
          androidNotificationConfig: ZegoCallAndroidNotificationConfig(
              channelID: 'high_importance_channel',
              showOnLockedScreen: true,
              showOnFullScreen: true,
            callChannel: ZegoCallAndroidNotificationChannelConfig(
              channelID: "high_importance_channel",
              channelName: "High Importance Notifications",
              sound: "call",
              icon: "call",
            ),
            missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
              channelID: "high_importance_channel",
              channelName: "High Importance Notifications",
              sound: "missed_call",
              icon: "missed_call",
              vibrate: false,
            ),
          ),
          iOSNotificationConfig: ZegoCallIOSNotificationConfig(
            systemCallingIconName: 'CallKitIcon',
          ),
        ),
        plugins: [ZegoUIKitSignalingPlugin()],
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
          onIncomingCallAcceptButtonPressed: onIncomingCallAcceptButtonPressed,
          onIncomingCallDeclineButtonPressed: onIncomingCallDeclineButtonPressed,
          onIncomingCallCanceled: onIncomingCallCanceled,
          onIncomingCallReceived: onIncomingCallReceived,
          onIncomingMissedCallClicked: onIncomingMissedCallClicked,
          onIncomingMissedCallDialBackFailed: onIncomingMissedCallDialBackFailed,
        ),
        config: ZegoCallInvitationConfig(
          endCallWhenInitiatorLeave: true,
          offline: ZegoCallInvitationOfflineConfig(
            autoEnterAcceptedOfflineCall: true,
          ),
          missedCall: ZegoCallInvitationMissedCallConfig(
            enabled: true,
            enableDialBack: true,
          ),
        ),
        events: ZegoUIKitPrebuiltCallEvents(
          onCallEnd: onCallEnd,
          onHangUpConfirmation: onHangUpConfirmation,
          onError: onError,
        ),
        requireConfig: (data) {
          final config = (data.invitees.length > 1) ?
          ZegoCallType.videoCall == data.type ?
          ZegoUIKitPrebuiltCallConfig.groupVideoCall() :
          ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
              : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

          config.rootNavigator = true;
          config.screenSharing = ZegoCallScreenSharingConfig(defaultFullScreen: true);

          /// show minimizing button
          config.topMenuBar.isVisible = true;
          config.pip.enableWhenBackground = true;
          config.pip.iOS.support = true;

          config.topMenuBar.buttons
            ..insert(0, ZegoCallMenuBarButtonName.minimizingButton)
            // ..insert(0, ZegoCallMenuBarButtonName.pipButton)
            ..insert(0, ZegoCallMenuBarButtonName.showMemberListButton);
          // من برا قبل ما يخش الكول
          // config.topMenuBar.buttons = [
          //   ZegoCallMenuBarButtonName.minimizingButton,
          //   ZegoCallMenuBarButtonName.switchCameraButton,
          // ];

          // config.bottomMenuBarConfig.buttons = [
          //   ZegoCallMenuBarButtonName.toggleMicrophoneButton,
          //   ZegoCallMenuBarButtonName.toggleCameraButton,
          //   ZegoCallMenuBarButtonName.hangUpButton,
          // ];

          config.layout = ZegoLayout.pictureInPicture(
            isSmallViewDraggable: true,
            switchLargeOrSmallViewByClick: true,
            isSmallViewsScrollable: true,
            showNewScreenSharingViewInFullscreenMode: true,
          );

          if (addChatButton) {
            config.bottomMenuBarConfig.buttons.add(ZegoCallMenuBarButtonName.chatButton);
          }


          config.duration.isVisible = true;
          if(ZegoCallType.videoCall == data.type){
            _endVideoCall(onCallStarted: onCallStarted);
            if (callDuration.isNotNull) {
              config.duration.onDurationUpdate = (Duration duration) {
                if (duration.inSeconds == callDuration!.inSeconds) {
                  ZegoUIKitPrebuiltCallController().hangUp(navigatorKey.currentState!.context);
                }
              };
            }
          }

          return config;
        },
      );


      _handleOffline();
      return await _waitForSignalingConnection();
    } on Exception catch (e) {
      log('the error is ${e.toString()}');
      return false;
    }
  }

  void _handleOffline(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoUIKitPrebuiltCallInvitationService().enterAcceptedOfflineCall();
    });
  }

  void _endVideoCall({
    void Function()? onCallStarted,
  }){
    ZegoUIKit().getUserJoinStream().listen((joinedUsers) {
      for(var user in joinedUsers){
        log('the user ${user.name} is joined');
        log('the users ${joinedUsers.length}');
      }

      log(joinedUsers.length.isNotEqualZero.toString());
      if(joinedUsers.length.isNotEqualZero){
        onCallStarted?.call();
      }
    });
  }

  Future<bool> _waitForSignalingConnection() async {
    log('✅ Signaling connection test');
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      final connectionState = ZegoUIKitSignalingPlugin().getConnectionState();

      if (connectionState == ZegoSignalingPluginConnectionState.connected) {
        isConnected.value = true;
        log('✅ Signaling connected successfully');
        return true;
      }

      log('⏳ Waiting for signaling connection... (${attempts + 1} / $maxAttempts)');
      await Future.delayed(const Duration(seconds: 1));
      attempts++;
    }

    log('⚠️ Signaling connection timeout');
    return false;
  }

  Future<void> onUserLogout() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  Widget zegoButton({
    bool isVideoCall = false,
    required Widget icon,
    required List<ZegoUIKitUser> invites,
    void Function()? onPressed,
    required BuildContext context,
  }) => ZegoSendCallInvitationButton(
    isVideoCall: isVideoCall,
    icon: ButtonIcon(icon: icon),
    iconSize: Size(25.w, 25.h),
    onPressed: (c, v, b) {
      onPressed?.call();
    },
    resourceID: "satr-id",
    invitees: invites,
  );
}