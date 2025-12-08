part of '../imports.dart';

class ChatScreen extends StatelessWidget {
  final RequestModel requestModel;
  final String receiverName;
  final bool showFullChat;

  const ChatScreen({super.key,
    required this.requestModel,
    required this.receiverName,
    this.showFullChat = true
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
          showFullChat: showFullChat,
          receiverName: receiverName,
        )
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  final String receiverName;
  final bool showFullChat;
  final RequestModel requestModel;

  const _ChatScreenBody({
    required this.requestModel,
    required this.receiverName,
    required this.showFullChat,
  });

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {


  Widget _upperWidget(ChatModel model){
    final int? timer = model.matchRequest!.timer;
    if(timer.isNotNull && timer.isNotEqualZero){
      return ChatTimerWidget(
        minutes: model.matchRequest?.timer ?? 5,
        phaseTitle: '',
      );
    }

    return const SizedBox.shrink();
  }

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



  // 115|09N2VmQioc78p3SW7mXip38b0i7vd7HVNsNemq6X female
  // 114|1bMeD26fYHWl2e85f2oUnhlvDynkHOVvcqVVzQVn male
  ChatActions _manageSuccessState(ChatModel data) {
    final timer = data.matchRequest!.timer;
    final stage = data.matchRequest!.stage!.value?.getCurrentStageAsStagesEnum;
    final userStatus = data.matchRequest!.userRequestStatus!.getUserRequestStatusAsEnum;
    final matchRequest = data.matchRequest!.userRequest!.getMatchRequestAsEnum;
    final currentTips = data.matchRequest!.tipsPage!.currentStageTips;

    // tips
    if(!currentTips.isNoPage){
      return TipsAction(
          context: context,
          currentTips: currentTips,
          requestModel: widget.requestModel
      );
    }

    // based stage
    if(stage!.isParentsExchangeNumber){
      return StageAction(context: context, stage: stage);
    }

    // acceptance - payment
    if(!userStatus.isUndefined){
      return UserStatusAction(
          context: context,
          stage: stage,
          status: userStatus,
          request: matchRequest,
          matchReqId: context.read<ChatCubit>().matchRequestId!,
          requestModel: widget.requestModel
      );
    }

    // timer
    if(timer.isEqualZero){
      return TimerAction(context: context, requestModel: widget.requestModel, stage: stage);
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
    if(widget.showFullChat){
      await _startChat();
      await Helpers.initZegoService(
        onCallStarted: (){
          context.read<EndVideoCallCubit>().endVideoCall( // برنها وانا فالكول
              context.read<ChatCubit>().matchRequestId.toString()
          );
        }
      );
      _initSocket();
    }
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
        appBarTitle: LocaleKeys.chat,
        isScrollable: false,
        actions: widget.showFullChat? [

          ValueListenableBuilder(
              valueListenable: ZegoService.isConnected,
              builder: (context, isConnected, child) => isConnected? Helpers.zegoService!.zegoButton(
                isVideoCall: false,
                icon: const SvgPic(assetName: Assets.svgPhoneIcon),
                invites: [
                  ZegoUIKitUser(id: widget.requestModel.receiverId.toString(), name: widget.receiverName)
                ],
              ) : CustomLoading.showLoadingView()
          ),

            BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
              builder: (context, state) => StatusBuilder(
                data: state,
                onSuccess: (data, context) {
                  final callStatus = context.read<ChatCubit>().matchRequest?.callStatus;
                  final currentStage = context.read<ChatCubit>().currentStage!.value!.getCurrentStageAsStagesEnum;
                  if((!(callStatus == 'not_available') || (callStatus == 'free_available') || (callStatus == 'paid_available')) &&
                      currentStage.isShariaComplaintMeeting){
                    return ValueListenableBuilder(
                        valueListenable: ZegoService.isConnected,
                        builder: (context, isConnected, child) => isConnected? Helpers.zegoService!.zegoButton( // المحانية موجودة
                            isVideoCall: true,
                            icon: const SvgPic(assetName: Assets.svgVideoCall),
                            invites: [
                              ZegoUIKitUser(id: widget.requestModel.receiverId.toString(), name: widget.receiverName)
                            ],
                            // onPressed: (){
                            //   if(callStatus == 'free_available' || callStatus == 'paid_available'){
                            //
                            //
                            //   }
                            // }
                        ) : const SizedBox.shrink()
                    );

                  }else if(callStatus == 'free_used'){ // بتبعت هنا ريكويست اني عايز التانية
                    context.read<ChatCubit>().executeRequest(
                        requestModel: widget.requestModel,
                        path: ApiConstants.videoCallRequest,
                        onSuccess: (data) => MessageUtils.showSnackBar(LocaleKeys.aVideoCallRequestWasSuccessfullySent)
                    );

                  }else if(callStatus == 'completed'){ // المحانية خلصت
                    return const SvgPic(assetName: Assets.svgVideoCall, color: Colors.grey);

                  }

                  return const SizedBox.shrink();
                }


              ),
            ),

        ] : null,
        body: Column(
          children: [
            if(widget.showFullChat)
              Row(
                spacing: context.width / 5,
                children: [
                  ChatReportIcon(id: int.parse(widget.requestModel.receiverId)),
                  BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
                      builder: (context, state) => StatusBuilder(
                          data: state,
                          onSuccess: (data, context) => _upperWidget(data)
                      )),
                ],
              ),

            Expanded(
              child: EasyChat(
                // itemExtent: 60.h,
                controller: _chatController,
                emptyView: const Center(
                  child: NotContainData(),
                ),
                asyncCall: (context, page) async => await ChatsData.getChatMessages(
                    requestModel: widget.requestModel
                ),
                errorBuilder: (e) => const ExceptionView(),
                errorMapper: PagifyErrorMapper(errorWhenDio: (e) => e.response?.data['msg']),
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
              ),
            ),
          ],
        ),
        bottomBar: widget.showFullChat? BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) =>
                IntrinsicHeight(
                  child: StatusBuilder(
                    data: state,
                    onFail: () => AppText(LocaleKeys.exceptionError),
                    onSuccess: (data, context) => _initBottomBar(state.data),
                  ),
                )
        ) : const SizedBox.shrink(),
      ),
    );
  }
}