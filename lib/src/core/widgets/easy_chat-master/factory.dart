import 'dart:async';
import 'dart:developer';
import '../../../features/chats/data/models/message_params_model.dart';
import 'models/chat_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketEvents{
  static const String enterChat = 'enter-chat';
  static const String sendMsg = 'send-message';
  // static const String sendMessageEvent = 'sendMessage';

  static const String exitChat = 'exit-chat';
}

abstract interface class SocketHelper{
  final String url;
  ChatMessages Function(Map<String, dynamic> jsonMessage) jsonToChatMessage;
  FutureOr<void> Function(ChatMessages message) onReceiveMessage;

  SocketHelper({
    required this.url,
    required this.jsonToChatMessage,
    required this.onReceiveMessage
  });

  FutureOr<void> connect({dynamic Function(dynamic)? handler});
  FutureOr<void> disconnect({dynamic Function(dynamic)? handler});
}

class ClientIOImpl extends SocketHelper{
  ClientIOImpl({
    required super.url,
    required super.jsonToChatMessage,
    required super.onReceiveMessage
  });


  late final IO.Socket socket;
  void _init(){
    socket = IO.io(url, IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect()  // disable auto-connection
        .setExtraHeaders(MessageParamsModel().toJson())
        .setQuery(MessageParamsModel().toJson())
        .build()
    )..connect();
  }

  @override
  FutureOr<void> connect({dynamic Function(dynamic)? handler}) {
    _init();

    socket.onConnect((d) {
      handler?.call(d);
      log('Socket connected');
      socket.emit(SocketEvents.enterChat);
    });

    socket.onDisconnect((_) => log('⚠️ Disconnected from socket'));
    socket.onConnectError((err) => log('❌ Socket connect error: $err'));
    socket.onError((err) => log('❌ Socket error: $err'));

    onReceiveMsg();
  }

  @override
  FutureOr<void> disconnect({dynamic Function(dynamic)? handler}) {
    socket.disconnect();
    socket.dispose();
  }

  // @override
  // void onReceiveMessage(String event, {required FutureOr<void> Function(ChatMessages message) handler}) {
  //   socket.on(event, (v)async =>  await handler.call(jsonToChatMessage.call(v)));
  // }

  void onReceiveMsg(){
    socket..on(
        SocketEvents.sendMsg,
            (data) {
          log('data is delivered');
          log(data.toString());
          onReceiveMessage.call(data);
        }
    )..on(
        SocketEvents.exitChat,
            (data) {
          log('data is delivered');
          log(data.toString());
          onReceiveMessage.call(data);
        }
    )..on(
        SocketEvents.enterChat,
            (data) {
          log('data is delivered');
          log(data.toString());
          onReceiveMessage.call(data);
        }
    );
  }

  FutureOr<void> send({
    required String event,
    dynamic data,
  }) {
    log('msg is sent $data');
    socket.emit(event, [data]);
  }
}
