import 'dart:async';
import 'models/chat_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


abstract interface class SocketHelper{
  final String url;
  ChatMessages Function(Map<String, dynamic> jsonMessage) jsonToChatMessage;
  SocketHelper({required this.url, required this.jsonToChatMessage});

  FutureOr<void> connect();
  FutureOr<void> disconnect();
  FutureOr<void> send({
    required String event,
    dynamic data,
});
  Stream<ChatMessages> onReceiveMessage(); // should make json parsing here to chat message
}

class ClientIOImpl extends SocketHelper{
  ClientIOImpl({required super.url, required super.jsonToChatMessage});

  late final IO.Socket socket;
  void _init(){
    socket = IO.io(url);
  }

  final List<String> events = [];

  @override
  FutureOr<void> connect() {
    _init();
    socket..onConnect((handler){})
    ..on('eventName', (data){})
      ..onDisconnect((handler){});
  }

  @override
  FutureOr<void> disconnect() {
    socket.disconnect();
    socket.dispose();
  }

  @override
  Stream<ChatMessages> onReceiveMessage() {
    // socket.on(event, handler)
    // TODO: implement onReceiveMessage
    throw UnimplementedError();
  }

  @override
  FutureOr<void> send({
    required String event,
    dynamic data,
  }) {
    socket.emit(event, [data]);
  }

}
