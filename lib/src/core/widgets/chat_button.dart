import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/chats/data/models/chat_model.dart';
import '../../features/chats/data/models/message_params_model.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/data/socket_events.dart';
import '../../features/chats/presentation/cubits/check_chat_eligibility_cubit.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../helpers/cache_service.dart';
import '../network/dio_service.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import '../socket_service/client_io.dart';
import 'chat_builder/chat_message.dart';
import 'buttons/app_loading_button.dart';
import 'custom_messages.dart';

class ChatButton extends StatefulWidget {
  final UserModel user;
  const ChatButton({super.key, required this.user});

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  SocketHelper? _socket;
  bool _hasSentInitialMessage = false;

  CanChat get _initialCanChat => widget.user.canChat ?? CanChat.initial();

  RequestModel get _requestModel => RequestModel(
        receiverId: widget.user.id.toString(),
        fromHome: 1.toString(),
      );

  String get _chatRequestMessage {
    final String currentUserName = UserModel.currentUser?.name ?? '';
    if (currentUserName.isEmpty) return LocaleKeys.wantToContactWithYou;
    return '$currentUserName ${LocaleKeys.isTryingToContactYou}';
  }

  String _buttonTitle(CanChat canChat) {
    return canChat.canChat
        ? LocaleKeys.sendChatRequest
        : canChat.reason.getReason;
  }

  Future<void> _initSocketAndSendInitialMessage({
    required CheckChatEligibilityCubit eligibilityCubit,
    required ChatModel chatModel,
  }) async {
    final int? roomId = chatModel.room?.id;
    if (roomId == null) return;
    final Completer<void> socketCompleter = Completer<void>();

    await _socket?.disconnect();
    _hasSentInitialMessage = false;

    final String storedSocketUrl =
        await SecureStorage.read(SecureLocalVariableKeys.socetIoUrl) ?? '';
    if (!mounted) return;

    _socket = ClientIOImpl(
      onConnect: (data) {
        log('socket connected');
        _sendInitialMessage(
          roomId: roomId,
          eligibilityCubit: eligibilityCubit,
        );
        if (!socketCompleter.isCompleted) socketCompleter.complete();
      },
      onDisconnect: (data) => log('socket disconnected'),
      onReconnect: (data) => log('socket reconnected'),
      onReceiveAnyEvent: (event, data) => log('event is received $event $data'),
      extraParams: MessageParamsModel().toJson(),
      url: storedSocketUrl,
      jsonToChatMessage: (json) => ChatMessages(
        message: Message(
          id: json['id'],
          type: json['type'],
          body: json['body'],
        ),
        sender: Sender(
          id: (json['sender_id']).toString(),
          name: json['sender_name'],
          image: json['avatar'],
          isFromMe: json['sender_id'] == UserModel.currentUser?.id,
        ),
        time: json['created_dt'],
      ),
      onReceiveMessage: (message) {},
      events: EasyChatEvents(
        messageEvents: MessageEvents(
          receiveMsgEvent: SocketEvents.receivedMsg,
          sendMsgEvent: SocketEvents.sendMsg,
        ),
        chatEvents: ChatEvents(
          enterChatEvent: SocketEvents.enterChat,
          exitChatEvent: SocketEvents.exitChat,
        ),
        otherEvents: [],
      ),
      roomId: roomId,
    )
      ..initSocket()
      ..initConfig()
      ..connect();
    await socketCompleter.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );
  }

  void _sendInitialMessage({
    required int roomId,
    required CheckChatEligibilityCubit eligibilityCubit,
  }) {
    final SocketHelper? socket = _socket;
    if (_hasSentInitialMessage || socket == null) return;
    _hasSentInitialMessage = true;
    socket.sendMessage({
      'room_id': roomId,
      'receiver_id': widget.user.id,
      'body': _chatRequestMessage,
      'type': 'text',
    });
    MessageUtils.showSnackBar(LocaleKeys.aChatRequestWasSuccessfullySent);
    eligibilityCubit.markChatRequestSent();
  }

  @override
  void dispose() {
    _socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckChatEligibilityCubit(initialCanChat: _initialCanChat),
      child: BlocBuilder<CheckChatEligibilityCubit, AsyncState<CanChat>>(
        builder: (context, state) {
          final CanChat canChat = state.data;
          return AppLoadingButton(
            asyncCall: (context) async {
              final CheckChatEligibilityCubit eligibilityCubit =
                  context.read<CheckChatEligibilityCubit>();
              await eligibilityCubit.checkEligibility(
                requestModel: _requestModel,
                onEligible: (chatModel) => _initSocketAndSendInitialMessage(
                  eligibilityCubit: eligibilityCubit,
                  chatModel: chatModel,
                ),
              );
            },
            buttonColor: canChat.canChat ? null : Colors.grey[300],
            enabled: canChat.canChat,
            title: _buttonTitle(canChat),
          );
        },
      ),
    );
  }
}
