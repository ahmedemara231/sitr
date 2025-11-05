import 'dart:async';

class ChatStatus{
  final bool Function() condition;
  final FutureOr<void> Function() onTrue;

  ChatStatus({
    required this.condition,
    required this.onTrue,
  });
}

class StatusLoop{
  static Future<void> execute(List<ChatStatus> chatStatus)async{
    chatStatus.firstWhere(
            (e) => e.condition.call() == true
    ).onTrue.call();
  }
}