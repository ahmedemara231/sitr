class NotificationModel {
  String id;
  int type;
  String title;
  String body;
  NotificationData data;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        body: json["body"],
        data: NotificationData.fromJson(json["data"]),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "body": body,
    "data": data.toJson(),
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
