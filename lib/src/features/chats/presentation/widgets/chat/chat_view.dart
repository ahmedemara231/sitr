import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart' show PaginationData, PagifyData;
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';

import '../../../../../config/language/languages.dart';
import '../../../../../core/widgets/chat_builder/chat_message.dart';
import '../../../../../core/widgets/chat_builder/easy_chat.dart';
import '../../../../../core/widgets/custom_loading.dart' show CustomLoading;
import '../../../../../core/widgets/custom_messages.dart';
import '../../../../../core/widgets/exeption_view.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../../data/chats_data.dart' show ChatsData;
import '../../../data/models/request_model.dart';
import 'message_widget.dart';

class ChatView extends StatefulWidget {
  final RequestModel requestModel;
  final PagifyController<ChatMessages> chatController;
  const ChatView({super.key, required this.requestModel, required this.chatController});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {


  MainAxisAlignment get _alignmentWhenMe => Languages.currentIsArabic?
  MainAxisAlignment.start : MainAxisAlignment.end;

  MainAxisAlignment get _alignmentWhenNotMe => Languages.currentIsArabic?
  MainAxisAlignment.end : MainAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    return EasyChat(
      controller: widget.chatController,
      messageAlignment: (fromMe) => fromMe?
      _alignmentWhenMe : _alignmentWhenNotMe,
      emptyView: const Center(
        child: NotContainData(),
      ),
      asyncCall: (context, page) async => await ChatsData.getChatMessages(
          requestModel: widget.requestModel
      ),
      onError: (c, page, e) => MessageUtils.showTopMsg(e.msg),
      errorBuilder: (e) => const ExceptionView(),
      errorMapper: PagifyErrorMapper(
          errorWhenDio: (e) {
            final String? msg = e.response?.data['msg'];
            return PagifyApiRequestException(
              msg ?? 'network error occur',
              pagifyFailure: RequestFailureData(
                statusCode: e.response?.statusCode,
                statusMsg: e.response?.statusMessage,
              ),
            );
          } // if you using Dio
      ),
      loadingBuilder: CustomLoading.showLoadingView(),
      mapper: (response) => PagifyData(
          data: response.room!.messages!.data!,
          paginationData: PaginationData(
              perPage: response.room!.messages!.pagination!.perPage,
              totalPages: response.room!.messages!.pagination!.totalPages
          )
      ),


      rightMessageBuilder: (msg) => ChatMessageWidget(message: msg),
      leftMessageBuilder: (msg) => ChatMessageWidget(message: msg),
    );
  }
}
