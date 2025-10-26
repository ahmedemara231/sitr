import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

import 'models/chat_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketEvents{
  static const String enterChat = 'enter-chat';
  static const String sendMsg = 'send-message';
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

//   FutureOr<void> send({
//     required String event,
//     dynamic data,
// });
//   void onReceiveMessage(
//       String event, {
//         required FutureOr<void> Function(ChatMessages event) handler
//       }); // should make json parsing here to chat message
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
        .setExtraHeaders({'foo': 'bar'}) // optional
        .build()
    );
  }

  @override
  FutureOr<void> connect({dynamic Function(dynamic)? handler}) {
    _init();
    socket.connect();
    socket.onConnect((d) {
      handler?.call(d);

      log('connect');
      socket.emit('msg', 'test');
    });
  }

  @override
  FutureOr<void> disconnect({dynamic Function(dynamic)? handler}) {
    socket.disconnect();
    socket.dispose();
    socket.onDisconnect.call((d) => handler?.call(d));
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
