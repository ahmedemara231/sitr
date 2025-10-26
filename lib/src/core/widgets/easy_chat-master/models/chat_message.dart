class ChatMessages{
  final String senderImage;
  final String senderName;
  final String message;
  final String? time;
  final bool  isFromMe;
  final String  type;
  final int id;
  final int senderId;

  ChatMessages({
    required this.senderImage,
    required this.message,
    this.time,
    required this.isFromMe,
    required this.type,
    required this.id,
    required this.senderId,
    required this.senderName,
  });

/*
* {
                        "id": 1,
                        "sender_id": 2,
                        "is_sender": false,
                        "body": "Hanging",
                        "type": "text",
                        "duration": 0,
                        "name": "",
                        "created_at": "منذ 5 ثواني",
                        "avatar": "https://setr.test/storage/uploads/users/2.png"
                    }*/

  factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
    senderImage: json['avatar'],
    message: json['body'],
    time: json['created_at'],
    isFromMe: json['is_sender'],
    type: json['type'],
    id: json['id'],
    senderId: json['sender_id'],
    senderName: json['name'],
  );


  Map<String, dynamic> toJson() => {
    'senderImage': senderImage,
    'message': message,
    'time': time,
    'isFromMe': isFromMe,
    'type': type,
    'id': id,
    'senderId': senderId,
    'senderName': senderName
  };
}