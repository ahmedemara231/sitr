import '../../../shared/models/user_models/user_model.dart';

class ChatMessages{
  final String message;
  final String type;


  final bool  isFromMe;
  final String? senderImage;
  final String? senderName;
  final String? time;
  final int? id;
  final int? senderId;

  ChatMessages({
    required this.message,
    required this.type,

    this.senderImage,
    this.time,
    this.isFromMe = false,
    this.id,
    this.senderId,
    this.senderName,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
    senderImage: json['avatar'],
    message: json['body'],
    time: json['created_at'],
    // isFromMe: (json['is_sender']) is int?
    // json['is_sender'] == 1? false : true :
    // json['is_sender'],

    // isFromMe: json['is_sender'] == 0? false : true,
    isFromMe: (json['sender_id'] as int) == UserModel.currentUser?.id,
    type: json['type'],
    id: json['id'],
    senderId: json['sender_id'],
    senderName: json['name'],
  );


  Map<String, dynamic> toJson() => {
    'body': message,
    'type': type,

    // 'senderImage': senderImage,
    // 'time': time,
    // 'isFromMe': isFromMe,
    // 'id': id,
    // 'senderId': senderId,
    // 'senderName': senderName
  };
}