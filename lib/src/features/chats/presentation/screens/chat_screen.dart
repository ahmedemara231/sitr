import 'dart:developer';

import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';
import 'package:zego_uikit/zego_uikit.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/int.dart';
import '../../../../core/extensions/num.dart';
import '../../../../core/extensions/remote_notification.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/easy_chat-master/easy_chat.dart';
import '../../../../core/widgets/easy_chat-master/factory.dart';
import '../../../../core/widgets/easy_chat-master/models/chat_message.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/chat_requests_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../data/chat_notification_service.dart';
import '../../data/chats_data.dart';
import '../../enums.dart';
import '../cubits/notification_cubit.dart';
import '../cubits/request_cubit.dart';
import '../widgets/chat/bottom_bar.dart';
import '../widgets/chat/message_widget.dart';

class ChatScreen extends StatefulWidget {
  final int receiverId;
  final int fromHome;

  ChatScreen({super.key,
    required this.receiverId,
    required this.fromHome,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final PagifyController<ChatMessages> _chatController = PagifyController<ChatMessages>();

  late final socket = ClientIOImpl(
    url: ConstantManager.socketUrl,
    jsonToChatMessage: (json) => ChatMessages.fromJson(json),
    onReceiveMessage: (msg) {
      _chatController.addItem(msg);
      _chatController.moveToMaxBottom();
    }
  );

  late final EasyTimerController _timerCont;

  @override
  void initState() {
    _timerCont = EasyTimerController();
    super.initState();
  }

  @override
  void dispose() {
    _timerCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatNotificationCubit(injector<ChatNotificationService>()),
      child: BlocConsumer<ChatNotificationCubit, ChatNotificationState>(
        listener: (context, state) {
          log('the notification is received ${state.notification}');
          log('the notification is received ${state.notificationType}');
        },
        builder: (context, state) => AppScaffold(
          appBarTitle: LocaleKeys.chat,
          isScrollable: false,
          // actions: [
          //   Helpers.zegoService.zegoButton(
          //       isVideoCall: false,
          //       icon: const SvgPic(assetName: Assets.svgPhoneIcon),
          //       invites: [
          //         ZegoUIKitUser(id: '145', name: 'jzjdjjdjd')
          //       ],
          //   )
          // ],
          body: Column(
            children: [
              // if(state.notification?.getCurrentStageAsInt.getCurrentStageAsStagesEnum.isFamiliarityStage ?? false)
                EasyTimerCount.builder(
                controller: _timerCont,
                  duration: EasyTime(seconds: ChatsData.chatModel?.room?.timer ?? 5),
                  builder: (time) => Column(
                    spacing: 10.h,
                    children: [
                      AppText(LocaleKeys.sufficientKnowledge),
                      Row(
                        spacing: 5.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timelapse, color: Colors.amber),
                          AppText(time, fontSize: 22.sp, fontWeight: FontWeight.w500),
                        ],
                      )
                    ],
                  ),
                  onTimerStarts: (context){},
                  onTimerEnds: (context) {}
                  // onTimerEnds: (context) => WidgetsBinding.instance.addPostFrameCallback(
                  //         (_) => showDefaultBottomSheet(
                  //             child: ChooseRequestSheet(
                  //               onConfirm: (context, selectedVal) async => context.read<RequestCubit>().executeRequest(
                  //                   requestModel: requestModel,
                  //                   path: selectedVal.pathToRequest
                  //               ),
                  //               titles: [
                  //                 LocaleKeys.moveToNextStage,
                  //                 LocaleKeys.refuseMoveToNextStage,
                  //                 LocaleKeys.requestForExtensionOfPeriod
                  //               ],
                  //             )
                  //         )
                  // )
              ),
              Expanded(
                child: EasyChat(
                  // itemExtent: 60.h,
                  socketType: socket,
                  controller: _chatController,
                  asyncCall: (context, page) async => await ChatsData.startChat(
                    ApiConstants.startChat,
                    fromHome: widget.fromHome,
                    receiverId: widget.receiverId,
                    onSuccess: (stage) => 'stage.isNewChat?'
                  ),
                  errorMapper: PagifyErrorMapper(errorWhenDio: (e) => e.response?.data['msg']),
                  mapper: (response) => PagifyData(
                      data: response.room!.messages!.data!,
                      paginationData: PaginationData(
                          perPage: response.room!.messages!.pagination!.perPage,
                          totalPages: response.room!.messages!.pagination!.totalPages
                      )
                  ),


                  rightMessageBuilder: (msg) => ChatMessageWidget(message: msg),
                  leftMessageBuilder: (msg) => ChatMessageWidget(message: msg),
                ),
              ),
            ],
          ),
          bottomBar: ChatBottomBar(
              onUpload: (url){
                socket.send(
                  event: SocketEvents.sendMsg,
                  data: ChatMessages(
                    message: url,
                    type: 'image',
                  ).toJson()..addAll({
                    'room_id' : ChatsData.chatModel?.room?.id,
                  }),
                );
              },
              onSend: (context, msg) => socket.send(
                event: SocketEvents.sendMsg,
                data: ChatMessages(
                    message: msg,
                    type: 'text',
                ).toJson()..addAll({
                  'room_id' : ChatsData.chatModel?.room?.id,
                }),
              )
          ),
        ),
      ),
    );
  }
}