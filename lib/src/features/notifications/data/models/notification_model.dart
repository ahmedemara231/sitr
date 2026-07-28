import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
  });

  factory NotificationModel.initial() => const NotificationModel(
        id: '',
        type: '',
        title: '',
        body: '',
        data: null,
        createdAt: '',
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
      data: json['data'] == null
          ? null
          : Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'body': body,
        'data': data,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [id, type, title, body, data, createdAt];
}

class NotificationData extends Equatable {
  final String type;
  final int clientId;

  const NotificationData({
    required this.type,
    required this.clientId,
  });

  factory NotificationData.initial() =>
      const NotificationData(type: '', clientId: 0);

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] ?? '',
      clientId: json['client_id'] ?? 0,
    );
  }

  NotificationData copyWith({
    String? type,
    int? clientId,
  }) {
    return NotificationData(
      type: type ?? this.type,
      clientId: clientId ?? this.clientId,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'client_id': clientId,
      };

  @override
  List<Object?> get props => [type, clientId];
}
