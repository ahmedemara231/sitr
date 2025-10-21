import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/easy_chat-master/easy_chat.dart';
import '../../../../core/widgets/easy_chat-master/factory.dart';
import '../../../../core/widgets/easy_chat-master/models/chat_message.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../cubits/start_chat.dart';
import '../widgets/chat/bottom_bar.dart';
import '../widgets/chat/message_widget.dart';

class ChatScreen extends StatelessWidget {
  final int receiverId;
  final int fromHome;

  ChatScreen({super.key,
    required this.receiverId,
    required this.fromHome,
  });

  final PagifyController<ChatMessages> _chatController = PagifyController<ChatMessages>();
  Future<List<ChatMessages>> testFun(int currentPage)async {
    final List<ChatMessages> msgs = [];
    await Future.delayed(const Duration(seconds: 2));

    msgs.addAll([
      ChatMessages(senderImage: 'image', message: 'message1', time: 'time1', isFromMe: true),
      ChatMessages(senderImage: 'image', message: 'message2', time: 'time1', isFromMe: true),
      ChatMessages(senderImage: 'image', message: 'message3', time: 'time1', isFromMe: false),
      ChatMessages(senderImage: 'image', message: 'message4', time: 'time1', isFromMe: false),
      ChatMessages(senderImage: 'image', message: 'message5', time: 'time1', isFromMe: true),
      ChatMessages(senderImage: 'image', message: 'message6', time: 'time1', isFromMe: false),
    ]);

    return msgs;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartChatCubit()..startChat(receiverId: receiverId, fromHome: fromHome),
      child: AppScaffold(
        appBarTitle: LocaleKeys.chat,
        body: EasyChat(
          itemExtent: 60.h,
          socketType: ClientIOImpl(
            url: 'server url',
            jsonToChatMessage: (jsonMessage) => ChatMessages(
                senderImage: jsonMessage['senderImage'],
                message: jsonMessage['message'],
                time: jsonMessage['time'],
                isFromMe: jsonMessage['isFromMe']
            ),
          ),
          onReceiveMessage: (context, message) async{
            // if(message.isFromMe){
            //   _chatController.moveToMaxBottom();
            // }
            //
            // _chatController.addItem(message);
          },
          controller: _chatController,
          asyncCall: (context, page) async => await testFun(page),
          mapper: (response) => PagifyData(
              data: response,
              paginationData: PaginationData(
                  perPage: 10, totalPages: 3
              )
          ),

          errorMapper: PagifyErrorMapper(errorWhenDio: (e) => e.response?.data['msg']),
          rightMessageBuilder: (msg) => ChatMessageWidget(message: msg),
          leftMessageBuilder: (msg) => ChatMessageWidget(message: msg),
        ),

        bottomBar: ChatBottomBar(
            onSend: (context) => _chatController.addItem(ChatMessages(senderImage: '', message: 'message', time: 'time', isFromMe: true))
        ),
      ),
    );
  }
}