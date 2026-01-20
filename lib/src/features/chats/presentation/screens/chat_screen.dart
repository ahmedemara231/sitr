part of '../imports.dart';

class ChatScreen extends StatelessWidget {
  final RequestModel requestModel;
  final String receiverName;

  const ChatScreen({super.key,
    required this.requestModel,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatCubit()),
          BlocProvider(create: (context) => FinishChatCubit()),
          BlocProvider(create: (context) => EndVideoCallCubit()),
          BlocProvider(
            create: (context) => NotificationCubit(injector<ChatNotificationService>()),
          )
        ],
        child: _ChatScreenBody(
          requestModel: requestModel,
          receiverName: receiverName,
        )
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  final String receiverName;
  final RequestModel requestModel;

  const _ChatScreenBody({
    required this.requestModel,
    required this.receiverName,
  });

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {

  Widget _initBottomBar(ChatModel model){
    final userRequest = model.matchRequest!;
    final stage = userRequest.stage!.value!.getCurrentStageAsStagesEnum;
    final userRequestEnum = userRequest.userRequestStatus!.getUserRequestStatusAsEnum;


    if(stage.isNewChat && userRequestEnum.isPending){
      return AcceptOrRejectFirstStageWidget(
        onAccept: (context) async => ChatActions.executeReq(
          context: context,
          requestModel: widget.requestModel,
          path: ApiConstants.acceptRequest+context.read<ChatCubit>().userRequest!,
          onSuccess: (chatModel) => context.read<ChatCubit>().startChat(
              requestModel: widget.requestModel
          ),
        ),

        onReject: (context)async => ChatActions.executeReq(
            requestModel: widget.requestModel,
            context: context,
            path: ApiConstants.rejectAll,
            onSuccess: (chatModel) =>  Go.offAll(const HomeScreen())
        ),
      );
    }

    return ChatBottomBar(
        controller: _chatController,
        onUpload: (url){
          socketType.sendMessage(
              {
                'room_id' : model.room?.id,
                'body' : url.split("/").last,
                'type' : 'image'
              }
          );
        },
        onSend: (context, msg) => socketType.sendMessage(
            {
              'room_id' : model.room?.id,
              'body': msg,
              'type' : 'text',
            }
        )
    );
  }


  ChatActions _manageSuccessState(ChatModel data) {
    final timer = data.matchRequest!.timer;
    final stage = data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;
    final userStatus = data.matchRequest!.userRequestStatus!.getUserRequestStatusAsEnum;
    final matchRequest = data.matchRequest!.userRequest!.getMatchRequestAsEnum;
    final currentTips = data.matchRequest!.tipsPage!.currentStageTips;
    final String requestName = data.matchRequest!.requestName!;

    // tips
    if(!currentTips.isNoPage){
      return TipsAction(
          context: context,
          currentTips: currentTips,
          requestModel: widget.requestModel
      );
    }

    // based stage
    if(stage.isParentsExchangeNumber){
      return StageAction(context: context, stage: stage);
    }

    // acceptance - payment
    if(!userStatus.isUndefined){
      return UserStatusAction(
          context: context,
          requestName: requestName,
          stage: stage,
          status: userStatus,
          request: matchRequest,
          matchReqId: context.read<ChatCubit>().matchRequestId!,
          requestModel: widget.requestModel
      );
    }

    if(stage.isParentIndividualConversation){
      return NoAction();
    }

    // timer
    if(timer.isEqualZero){
      return TimerAction(
          context: context,
          requestModel: widget.requestModel,
          stage: stage
      );
    }

    return NoAction();
  }


  Future<void> _startChat()async{
    await context.read<ChatCubit>().startChat(
      requestModel: widget.requestModel,
      onSuccess: (data) => _manageSuccessState.call(data).call(),
    );
  }

  Future<void> _showBased(RemoteMessage notification)async{
    if((notification.data['action'] as Object?).isNotNull){
      _startChat();
    }
  }

  late final PagifyController<ChatMessages> _chatController;

  late final SocketHelper socketType = ClientIOImpl(
      onConnect: (d) => log('socket connected'),
      onDisconnect: (d) => log('socket disconnected'),
      onReconnect: (d) => log('socket reconnected'),
      onReceiveAnyEvent: (e, d) => log('event is received $e $d'),
      extraParams: MessageParamsModel().toJson(),
      url: ConstantManager.socketUrl,
      jsonToChatMessage: (json) => ChatMessages(
        message: Message(id: json['id'], type: json['type'], body: json['body']),
        sender: Sender(
            id: json['sender_id'],
            name: json['sender_name'],
            image: json['avatar'],
            isFromMe: (json['sender_id'] == UserModel.currentUser?.id)
        ),
        time: json['created_dt'],
        // messageState: MessageState.sent
      ),
      onReceiveMessage: (msg) {
        _chatController.addItem(msg);
        _chatController.moveToMaxBottom();
      }, events: EasyChatEvents(
      messageEvents: MessageEvents(
          receiveMsgEvent: SocketEvents.receivedMsg,
          sendMsgEvent: SocketEvents.sendMsg
      ), chatEvents: ChatEvents(
      enterChatEvent: SocketEvents.enterChat,
      exitChatEvent: SocketEvents.exitChat),
      otherEvents: []
  ), roomId: context.read<ChatCubit>().currentRoom?.id ?? 0
  );

  void _initSocket() async {
    socketType
      ..initSocket()
      ..initConfig()
      ..connect();
  }

  void _handleInitialState()async{
    _chatController = PagifyController<ChatMessages>();
    await _startChat();
    _initSocket();
  }

  @override
  void initState() {
    _handleInitialState();
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    socketType.disconnect();
    super.dispose();
  }

  Future<void> _makeVideoReq()async{
    await context.read<ChatCubit>().executeRequest(
        requestModel: widget.requestModel,
        path: ApiConstants.matchRequestAnd+ApiConstants.videoCallRequest,
        onSuccess: (data) => MessageUtils.showSnackBar(LocaleKeys.aVideoCallRequestWasSuccessfullySent)
    );
  }

 Future <void> _endVideoCall()async{
    log('end video call');
    await context.read<EndVideoCallCubit>().endVideoCall( // برنها وانا فالكول
        ChatsData.data!.matchRequest!.id.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationCubit, NotificationState>(
          listener: (context, state) async =>
              _showBased(state.notification!),
        ),

        // show toast based new stage
        // BlocListener<ChatCubit, AsyncState<ChatModel>>(
        //   listener: (context, state) async => state.isSuccess?
        //   MessageUtils.showSnackBar(state.errorMessage!) : null
        // )
      ],

      child: AppScaffold(
        appBarTitle: '${LocaleKeys.chat} (${context.read<ChatCubit>().currentStage?.text})',
        isScrollable: false,
        actions: [
          ValueListenableBuilder(
              valueListenable: ZegoService.isConnected,
              builder: (context, isConnected, child) => isConnected?
              Helpers.zegoService!.zegoButton(
                context: context,
                isVideoCall: false,
                icon: const SvgPic(assetName: Assets.svgPhoneIcon),
                invites: [
                  ZegoUIKitUser(id: widget.requestModel.receiverId.toString(), name: widget.receiverName),
                ],
              ) : CustomLoading.showLoadingView()
          ),

            BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
              builder: (context, state) => StatusBuilder(
                data: state,
                onSuccess: (data, context) {
                  final callStatus = context.read<ChatCubit>().matchRequest?.callStatus;
                  if(((callStatus == 'free_available') || (callStatus == 'paid_available'))){
                    return ValueListenableBuilder(
                        valueListenable: ZegoService.isConnected,
                        builder: (context, isConnected, child) => isConnected? Helpers.zegoService!.zegoButton( // المحانية موجودة
                            context: context,
                            isVideoCall: true,
                            icon: const SvgPic(assetName: Assets.svgVideoCall),
                            invites: [
                              ZegoUIKitUser(id: widget.requestModel.receiverId.toString(), name: widget.receiverName),
                            ],
                            onPressed: ()async{
                              if(callStatus == 'free_available'){
                                await _makeVideoReq();
                              }

                              await _endVideoCall();
                            }
                        ) : const SizedBox.shrink()
                    );

                  }else if(callStatus == 'free_used'){
                    return InkWell(
                        onTap: () => _makeVideoReq(),
                        child: const Icon(Icons.video_call)
                    );

                  }else if(callStatus == 'completed'){ // المحانية خلصت
                    return const SvgPic(assetName: Assets.svgVideoCall, color: Colors.grey);

                  }

                  // not available
                  return const SizedBox.shrink();
                }


              ),
            ),

        ],
        body: Column(
          children: [
            ChatUpperWidget.withTimer(requestId: widget.requestModel.receiverId),
            Expanded(
              child: ChatView(
                requestModel: widget.requestModel,
                chatController: _chatController,
              )
            ),
          ],
        ),
        bottomBar: BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) =>
                IntrinsicHeight(
                  child: StatusBuilder(
                    data: state,
                    onFail: () => AppText(LocaleKeys.exceptionError),
                    onSuccess: (data, context) => _initBottomBar(state.data),
                  ),
                )
        ),
      ),
    );
  }
}