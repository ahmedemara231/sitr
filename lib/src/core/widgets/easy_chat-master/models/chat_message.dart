class ChatMessages{
  final String senderImage;
  final String message;
  final String time;
  final bool  isFromMe;

  ChatMessages({
    required this.senderImage,
    required this.message,
    required this.time,
    required this.isFromMe,
  });

  // factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
  //     senderImage: json['senderImage'],
  //     message: json['message'],
  //     time: json['time'],
  //     isFromMe: json['isFromMe']
  // );

  // Map<String, dynamic> toJson() => {
  //   'senderImage': senderImage,
  //   'message': message,
  //   'time': time,
  //   'isFromMe': isFromMe
  // };
}