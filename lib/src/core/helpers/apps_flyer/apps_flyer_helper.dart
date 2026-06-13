import 'dart:developer';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

import '../../shared/models/user_models/user_model.dart';
import 'events.dart';

class AppyFlyerHelper{
  static late final AppsflyerSdk _appsflyerSdk;
  static Future<void> init()async{
    final AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      // afDevKey: Platform.isAndroid? 'StWx8Em3WFohBgA9vtdoT9' : 'StWx8Em3WFohBgA9vtdoT9',
      afDevKey: 'StWx8Em3WFohBgA9vtdoT9',
      appId: '6756270317',
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      // appInviteOneLink: oneLinkID, // Optional field
      // disableAdvertisingIdentifier: false, // Optional field
      // disableCollectASA: false, //Optional field
      // manualStart: false,
    ); // Optional field

    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    await _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true
    );

    _appsflyerSdk.startSDK(
      onSuccess: () {
        log("AppsFlyer SDK initialized successfully.");
      },
      onError: (int errorCode, String errorMessage) {
        log("Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
      },
    );
  }

  static void setUser(int userId){
    _appsflyerSdk.setCustomerUserId(userId.toString());
  }

  static Future<void> logEvent(FlyerEvents event)async{
    await _appsflyerSdk.logEvent(event.name, {
      'id' : UserModel.currentUser?.id,
      'name' : UserModel.currentUser?.name,
      'phone' : UserModel.currentUser?.phone,
      'gender' : UserModel.currentUser?.gender,
      'type' : UserModel.currentUser?.type,
    });
  }
}