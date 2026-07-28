import 'package:equatable/equatable.dart';

class MessageRequestModel extends Equatable {
  final int id;
  final String status;
  final String createdAt;
  final bool canAccept;
  final String? acceptBlockReason;
  final MessageRequestUserModel sender;

  const MessageRequestModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.canAccept,
    required this.sender,
    this.acceptBlockReason,
  });

  factory MessageRequestModel.initial() => MessageRequestModel(
        id: 0,
        status: '',
        createdAt: '',
        canAccept: false,
        sender: MessageRequestUserModel.initial(),
      );

  factory MessageRequestModel.fromJson(Map<String, dynamic> json) {
    return MessageRequestModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      canAccept: json['can_accept'] ?? true,
      acceptBlockReason: json['accept_block_reason'],
      sender: MessageRequestUserModel.fromJson(
        Map<String, dynamic>.from(
          json['sender'] as Map? ?? <String, dynamic>{},
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'created_at': createdAt,
        'can_accept': canAccept,
        'accept_block_reason': acceptBlockReason,
        'sender': sender.toJson(),
      };

  MessageRequestModel copyWith({
    int? id,
    String? status,
    String? createdAt,
    bool? canAccept,
    String? acceptBlockReason,
    MessageRequestUserModel? sender,
  }) {
    return MessageRequestModel(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      canAccept: canAccept ?? this.canAccept,
      acceptBlockReason: acceptBlockReason ?? this.acceptBlockReason,
      sender: sender ?? this.sender,
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        createdAt,
        canAccept,
        acceptBlockReason,
        sender,
      ];
}

class MessageRequestUserModel extends Equatable {
  final int id;
  final String name;
  final String nickName;
  final String avatar;
  final int age;
  final String city;
  final bool isPromoted;

  const MessageRequestUserModel({
    required this.id,
    required this.name,
    required this.nickName,
    required this.avatar,
    required this.age,
    required this.city,
    required this.isPromoted,
  });

  factory MessageRequestUserModel.initial() => const MessageRequestUserModel(
        id: 0,
        name: '',
        nickName: '',
        avatar: '',
        age: 0,
        city: '',
        isPromoted: false,
      );

  factory MessageRequestUserModel.fromJson(Map<String, dynamic> json) {
    return MessageRequestUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nickName: json['nick_name'] ?? '',
      avatar: json['avatar'] ?? '',
      age: json['age'] ?? 0,
      city: json['city'] ?? '',
      isPromoted: json['is_promoted'] ?? false,
    );
  }

  String get displayName => nickName.isNotEmpty ? nickName : name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nick_name': nickName,
        'avatar': avatar,
        'age': age,
        'city': city,
        'is_promoted': isPromoted,
      };

  MessageRequestUserModel copyWith({
    int? id,
    String? name,
    String? nickName,
    String? avatar,
    int? age,
    String? city,
    bool? isPromoted,
  }) {
    return MessageRequestUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      avatar: avatar ?? this.avatar,
      age: age ?? this.age,
      city: city ?? this.city,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nickName,
        avatar,
        age,
        city,
        isPromoted,
      ];
}
