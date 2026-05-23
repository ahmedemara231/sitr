import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/request_model.dart';
import '../cubits/get_chats_cubit.dart';
import '../imports.dart';
import '../screens/previous_chat_screen.dart';
import 'chat_card.dart';

class ChatListTile extends StatelessWidget {
  final ChatModel chatModel;
  final ChatType chatType;
  final int index;

  const ChatListTile({
    super.key,
    required this.chatModel,
    required this.chatType,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final requestModel = RequestModel(
          receiverId: '${chatModel.room?.members?.first.id}',
          fromHome: 0.toString(),
        );

        late Widget targetScreen;
        if (chatType == ChatType.current) {
          targetScreen = ChatScreen(
            receiverName: chatModel.room?.members?.first.name ?? '',
            requestModel: requestModel,
          );
        } else {
          targetScreen = PreviousChatScreen(
            chatType: chatType,
            requestModel: requestModel,
          );
        }

        context.read<GetChatsCubit>().resetUnreadMessagesCount(index);
        Go.to(targetScreen);
      },
      child: ChatCard(
        url: chatModel.room?.members?.first.image ?? '',
        time: chatModel.room?.lastMessageCreatedDt ?? '',
        partnerName: chatModel.room?.members?.first.name ?? '',
        subTitle: chatModel.room!.lastMessageBody?.isNotEmpty ?? false?
        chatModel.room!.lastMessageBody!.isImage ?
        LocaleKeys.photo : chatModel.room!.lastMessageBody!
            : LocaleKeys.noMessagesExistsYet,
        unreadMsgs: chatModel.room!.unreadMsgs ?? 0,
      ).paddingBottom(10.h),
    );
  }
}
