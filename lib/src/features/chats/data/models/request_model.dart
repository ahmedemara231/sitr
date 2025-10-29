class RequestModel{
  final String receiverId;
  final String matchRequestId;
  final String fromHome;

  RequestModel({
    required this.receiverId,
    required this.matchRequestId,
    required this.fromHome,
  });

  Map<String, dynamic> toJson() => {
    'receiver_id' : receiverId,
    'match_request_id' : matchRequestId,
    'from_home' : fromHome,
  };
}