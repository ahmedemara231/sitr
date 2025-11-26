class RequestModel{
  final String receiverId;
  final String fromHome;

  RequestModel({
    required this.receiverId,
    required this.fromHome,
  });

  Map<String, dynamic> toJson() => {
    'receiver_id' : receiverId,
    'from_home' : fromHome,
  };
}