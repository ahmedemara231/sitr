enum ButtonsState {
  show,
  accepted,
  none,
  rejected;

  static ButtonsState fromString(String? value) {
    switch (value) {
      case 'accepted':
        return ButtonsState.accepted;

      case 'rejected':
        return ButtonsState.rejected;

      case 'pending':
        return ButtonsState.show;

      default:
        return ButtonsState.none;
    }
  }
}

extension Check on ButtonsState{
  bool get isAccepted => this == ButtonsState.accepted;
  bool get isRejected => this == ButtonsState.rejected;
  bool get isShow => this == ButtonsState.show;
  bool get isNone => this == ButtonsState.none;
}

class NotificationModel {
  String id;
  String type;
  String title;
  String body;
  Map<String, dynamic>? data;
  String createdAt;
  ButtonsState? buttonsState;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    this.buttonsState,
  });

  // factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
  //   final json = message.data['data'];
  //   final dataMap = json["data"] as Map<String, dynamic>?;
  //   return NotificationModel(
  //     id: json["id"],
  //     type: json["type"],
  //     createdAt: json["created_at"],
  //     title: json["title"],
  //     body: Languages.currentIsArabic?
  //     json["body_ar"] : json["body_en"],
  //     data: dataMap,
  //     buttonsState: (dataMap?['show_accept_reject_buttons'] == true) ?
  //     ButtonsState.show : null,
  //   );
  // }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json["data"] as Map<String, dynamic>?;
    return NotificationModel(
      id: json["id"],
      type: json["type"],
      title: json["title"],
      body: json["body"],
      createdAt: json["created_at"],
      data: dataMap,
      buttonsState: ButtonsState.fromString(dataMap?['show_accept_reject_buttons']),
    );
  }

  NotificationModel copyWith({ButtonsState? buttonsState}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      data: data,
      createdAt: createdAt,
      buttonsState: buttonsState ?? this.buttonsState,
    );
  }

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
