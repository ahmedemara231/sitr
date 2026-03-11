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
          BlocProvider(create: (context) => SocketCubit()),
          BlocProvider(create: (context) => FinishChatCubit()),
          BlocProvider(create: (context) => EndVideoCallCubit()),
          BlocProvider(
            create: (context) => NotificationCubit(injector<ChatNotificationService>()),
          ),
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
              requestModel: widget.requestModel,
              context: context,
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


  Future<void> _startChat()async{
    await context.read<ChatCubit>().startChat(
      requestModel: widget.requestModel,
      context: context,
    );
  }

  Future<void> _showBased(RemoteMessage notification)async{
    if((notification.data['action'] as Object?).isNotNull){
      _startChat();
    }
  }

  StreamSubscription<List<ZegoUIKitUser>>? _callStartedSubscription;

  void _listenForCallStart() {
    _callStartedSubscription?.cancel();
    _callStartedSubscription = ZegoUIKit().getUserJoinStream().listen((joinedUsers) {
      if (joinedUsers.isNotEmpty) {
        _endVideoCall();
        _callStartedSubscription?.cancel();
        _callStartedSubscription = null;
      }
    });
  }

  late final PagifyController<ChatMessages> _chatController;

  late SocketHelper socketType;

  void _initSocket() async {
    socketType = ClientIOImpl(

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
        ),
        onReceiveMessage: (msg) {
          _chatController.addItem(msg);
          _chatController.moveToMaxBottom();
        },
        events: EasyChatEvents(
            messageEvents: MessageEvents(
                receiveMsgEvent: SocketEvents.receivedMsg,
                sendMsgEvent: SocketEvents.sendMsg
            ),
            chatEvents: ChatEvents(
                enterChatEvent: SocketEvents.enterChat,
                exitChatEvent: SocketEvents.exitChat
            ),
            otherEvents: []
        ),
        roomId: context.read<ChatCubit>().currentRoom?.id ?? 0,
    );
    context.read<SocketCubit>().setSocket(socketType);
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
    _callStartedSubscription?.cancel();
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
    await context.read<EndVideoCallCubit>().endVideoCall( // برنها وانا فالكول
        ChatsData.data!.matchRequest!.id.toString()
    );
  }

  void _markAsRead()async{
    final roomId = context.read<ChatCubit>().currentRoom?.id;
    await ChatsData.markRead(roomId!);
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationCubit, NotificationState>(
          listener: (context, state) async =>
              _showBased(state.notification!),
        ),
      ],

      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          _markAsRead();
          Go.back();
        },
        child: AppScaffold(
        customTitle: BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
          builder: (context, state) => ChatStatusBuilder(
              data: state,
              onSuccess: (data, context) => AppText(LocaleKeys.chat, fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black,)),
        ),
        isScrollable: false,
        onBack: () => _markAsRead(),
        actions: [
          BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) => ChatStatusBuilder(
              data: state,
              onSuccess: (data, context) => !data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum.isNewChat?
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
              ) : const SizedBox.shrink(),
            ),
          ),
          BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) => ChatStatusBuilder(
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
                            onPressed: () async {
                              if (callStatus == 'free_available') {
                                await _makeVideoReq();
                              }
                              _listenForCallStart();
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
                  child: ChatStatusBuilder(
                    data: state,
                    onSuccess: (data, context) => _initBottomBar(state.data),
                  ),
                )
        ),
      ),
      ),
    );
  }
}
