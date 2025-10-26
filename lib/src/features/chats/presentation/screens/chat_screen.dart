import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/num.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/easy_chat-master/easy_chat.dart';
import '../../../../core/widgets/easy_chat-master/factory.dart';
import '../../../../core/widgets/easy_chat-master/models/chat_message.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/chats_data.dart';
import '../cubits/send_message.dart';
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
  // Future<List<ChatMessages>> testFun(int currentPage)async {
  //   final List<ChatMessages> msgs = [];
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   msgs.addAll([
  //     ChatMessages(senderImage: 'image', message: 'message1', time: 'time1', isFromMe: true),
  //     ChatMessages(senderImage: 'image', message: 'message2', time: 'time1', isFromMe: true),
  //     ChatMessages(senderImage: 'image', message: 'message3', time: 'time1', isFromMe: false),
  //     ChatMessages(senderImage: 'image', message: 'message4', time: 'time1', isFromMe: false),
  //     ChatMessages(senderImage: 'image', message: 'message5', time: 'time1', isFromMe: true),
  //     ChatMessages(senderImage: 'image', message: 'message6', time: 'time1', isFromMe: false),
  //   ]);
  //
  //   return msgs;
  // }

  late final socket = ClientIOImpl(
    url: ConstantManager.socketUrl,
    jsonToChatMessage: (json) => ChatMessages.fromJson(json),
    onReceiveMessage: (msg) => _chatController.addItem(msg),
  );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: LocaleKeys.chat,
      body: EasyChat(
        itemExtent: 60.h,
        socketType: socket,
        // onReceiveMessage: (context, message) async{
        //   // if(message.isFromMe){
        //   //   _chatController.moveToMaxBottom();
        //   // }
        //   //
        //   log('add item');
        //   _chatController.addItem(message);
        // },
        controller: _chatController,
        asyncCall: (context, page) async => await ChatsData.getChats(
          ApiConstants.startChat,
          fromHome: fromHome,
          receiverId: receiverId
        ),
        mapper: (response) => PagifyData(
            data: response.room!.messages!.data!,
            paginationData: PaginationData(
                perPage: response.room!.messages!.pagination!.perPage,
                totalPages: response.room!.messages!.pagination!.totalPages
            )
        ),

        errorMapper: PagifyErrorMapper(errorWhenDio: (e) => e.response?.data['msg']),
        rightMessageBuilder: (msg) => ChatMessageWidget(message: msg),
        leftMessageBuilder: (msg) => ChatMessageWidget(message: msg),
      ),

      // body: Container(),
      bottomBar: BlocProvider(
        create: (context) => SendMsgCubit(),
        child: ChatBottomBar(
            onSend: (context, msg) => socket.send(
              event: SocketEvents.sendMsg,
              data: ChatMessages(
                  senderImage: UserCubit.instance.user.avatar??'',
                  message: msg,
                  isFromMe: true,
                  type: 'text',
                  id: UserCubit.instance.user.id??0,
                  senderId: UserCubit.instance.user.id??0,
                  senderName: UserCubit.instance.user.name??''
              ).toJson(),
            )
        ),
      ),
    );
  }
}
/*
* Map<String, dynamic> toJson() => {
    'senderImage': senderImage,
    'message': message,
    'time': time,
    'isFromMe': isFromMe,
    'type': type,
    'id': id,
    'senderId': senderId,
    'senderName': senderName
  };*/