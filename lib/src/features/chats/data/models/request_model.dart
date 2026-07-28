class RequestModel {
  final String receiverId;
  final String fromHome;

  const RequestModel({
    required this.receiverId,
    required this.fromHome,
  });

  Map<String, dynamic> toJson() => {
        'receiver_id': receiverId,
        'from_home': fromHome,
      };

  Map<String, dynamic> toMessageRequestJson() => {
        'receiver_id': receiverId,
      };
}
