import 'dart:developer';

import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/dropinity/helpers/extensions/object.dart';
import '../../../../core/extensions/int.dart';
import '../../../../core/extensions/num.dart';
import '../../../../core/extensions/remote_notification.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/easy_chat-master/easy_chat.dart';
import '../../../../core/widgets/easy_chat-master/factory.dart';
import '../../../../core/widgets/easy_chat-master/models/chat_message.dart';
import '../../../../core/widgets/exeption_view.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/chat_requests_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../home/home_screen.dart';
import '../../data/chat_notification_service.dart';
import '../../data/chats_data.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/request_model.dart';
import '../../enums.dart';
import '../cubits/notification_cubit.dart';
import '../cubits/request_cubit.dart';
import '../cubits/start_chat.dart';
import '../widgets/accept_or_reject_first_stage.dart';
import '../widgets/chat/bottom_bar.dart';
import '../widgets/chat/message_widget.dart';

class ChatScreen extends StatefulWidget {
  final int receiverId;
  final int fromHome;

  const ChatScreen({super.key,
    required this.receiverId,
    required this.fromHome,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _makeActionsBasedNotifications(RemoteMessage notification){
    log('the data is ${notification.data}');
    log('the data is ${notification.data['match_request_name']}');
    final matchRequestId = notification.data['match_request_id'];
    final matchRequestName = notification.data['match_request_name'];
    _openSheet(requestId: matchRequestId, requestName: matchRequestName);
    if(matchRequestId.getMatchRequest.isMoveToNext){

    }
    // else if(matchRequestId.getMatchRequest.isReject){
    //
    // }else if(matchRequestId.getMatchRequest.isExtension){
    //
    // }
    else{
      return;
    }
  }

  Widget _upperWidget(ChatModel model){
    final ChatStages currentStage = model.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;
    final int? timer = model.matchRequest!.timer;
    if(currentStage.isNewChat &&
        (timer.isNotNull || timer.isNotEqualZero)){
     return EasyTimerCount.builder(
          controller: _timerCont,
          duration: EasyTime(seconds: model.room?.timer ?? 5),
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
     );
    }

    return const SizedBox.shrink();
  }

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

  void _openSheet({
    required String requestId,
    required String requestName,
  }){
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => showDefaultBottomSheet(
            child: ChooseRequestSheet(
              onConfirm: (context, selectedVal) async {
                context.read<RequestCubit>().executeRequest(
                  onSuccess: (){},
                  requestModel: RequestModel(
                    receiverId: widget.receiverId.toString(),
                    fromHome: widget.fromHome.toString(),
                    matchRequestId: requestId.toString(),
                  ),
                  path: selectedVal.pathToRequest+requestId,
                );
              },
              titles: [
                LocaleKeys.moveToNextStage,
                LocaleKeys.refuseMoveToNextStage,
                LocaleKeys.requestForExtensionOfPeriod
              ],
            )
        )
    );
  }

  void _executeReq({
    required BuildContext context,
    required String path,
    required void Function() onSuccess
  }) => context.read<RequestCubit>().executeRequest(
      requestModel: RequestModel(
        receiverId: widget.receiverId.toString(),
        fromHome: widget.fromHome.toString(),
        matchRequestId: context.read<StartChatCubit>().matchRequestId.toString(),
      ),
      path: path+context.read<StartChatCubit>().userRequest!,
      onSuccess: onSuccess
  );

  Widget? _initBottomBar({
    required UserRequestStatus status,
    required ChatStages stage,
  }){
    if(stage.isNewChat && status.isPending){
      return AcceptOrRejectFirstStageWidget(
        onAccept: (context) async => _executeReq(
            context: context,
            path: ApiConstants.acceptRequest,
            onSuccess: () => context.read<StartChatCubit>().startChat(
                receiverId: widget.receiverId,
                fromHome: widget.fromHome,
            ),
        ),
        onReject: (context)async => _executeReq(
            context: context,
            path: ApiConstants.rejectRequest,
            onSuccess: () =>  Go.off(const HomeScreen())
        ),
      );
    }

    return null;
  }

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RequestCubit()),
        BlocProvider(
          create: (context) => StartChatCubit()..startChat(
              receiverId: widget.receiverId,
              fromHome: widget.fromHome,
          ),
        ),
        BlocProvider(
          create: (context) => ChatNotificationCubit(injector<ChatNotificationService>()),
        )
      ],
      child: BlocConsumer<ChatNotificationCubit, ChatNotificationState>(
        // النوتيفيكيشنز هي الوحيدة اللي هتطلع ال bottom sheet
        listener: (context, state) {
          log('the notification is received ${state.notification}');
          log('the notification is received ${state.notificationType}');
          _makeActionsBasedNotifications(state.notification!);
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
              BlocBuilder<StartChatCubit, AsyncState<ChatModel>>(
                  builder: (context, state) => StatusBuilder(
                    data: state,
                    onSuccess: (data, context) => _upperWidget(state.data)
                ),

              ),
              Expanded(
                child: EasyChat(
                  // itemExtent: 60.h,
                  socketType: socket,
                  controller: _chatController,
                  asyncCall: (context, page) async => await ChatsData.getChatMessages(
                    fromHome: widget.fromHome,
                    receiverId: widget.receiverId,
                  ),
                  errorBuilder: (e) => const ExceptionView(),
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
          bottomBar: BlocBuilder<StartChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) =>
            StatusBuilder(
              data: state,
              onSuccess: (data, context) =>
              _initBottomBar(
                  status: state.data.matchRequest!.userRequestStatus!.getUserRequestStatus,
                  stage: state.data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum
              ) ?? ChatBottomBar(
                      onUpload: (url){
                        socket.sendMsg(
                          event: SocketEvents.sendMsg,
                          data: ChatMessages(
                            message: url,
                            type: 'image',
                          ).toJson()..addAll({
                            'room_id' : state.data.room?.id,
                          }),
                        );
                      },
                      onSend: (context, msg) => socket.sendMsg(
                        event: SocketEvents.sendMsg,
                        data: ChatMessages(
                          message: msg,
                          type: 'text',
                        ).toJson()..addAll({
                          'room_id' : state.data.room?.id,
                        }),
                      )),
            )
          ),
        ),
      ),
    );
  }
}