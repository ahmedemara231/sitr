import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../config/language/languages.dart';
import '../../../../core/extensions/object.dart';

class NotificationModel {
  String id;
  String type;
  String title;
  String body;
  Map<String, dynamic>? data;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final json = message.data['data'];
    return NotificationModel(
      id: json["id"],
      type: json["type"],
      createdAt: json["created_at"],
      title: json["title"],
      body: Languages.currentIsArabic?
      json["body_ar"] : json["body_en"],
      data: json["data"]
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        body: json["body"],
        createdAt: json["created_at"],
        data: json["data"]
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "body": body,
    "data": data,
    "created_at": createdAt,
  };
}

class NotificationData {
  String type;
  int clientId;

  NotificationData({
    required this.type,
    required this.clientId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        type: json["type"],
        clientId: json["client_id"]??0,
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "client_id": clientId,
  };
}
