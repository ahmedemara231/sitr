import 'dart:async';
import 'dart:developer';
import 'package:easy_chat/easy_chat.dart';
import 'package:easy_chat/models/chat_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';
import 'package:zego_uikit/zego_uikit.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/dropinity/helpers/extensions/object.dart';
import '../../../../core/extensions/num.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/socket_service/client_io.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/exeption_view.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/chat_requests_sheet.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../core/widgets/sheets/tips_sheet.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../home/home_screen.dart';
import '../../../packages/presentation/screens/subscription_screen.dart';
import '../../data/chat_notification_service.dart';
import '../../data/chat_sheet_manager.dart';
import '../../data/chats_data.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_params_model.dart';
import '../../data/models/request_model.dart';
import '../../enums.dart';
import '../cubits/notification_cubit.dart';
import '../cubits/pay_request.dart';
import '../cubits/start_chat.dart';
import '../widgets/accept_or_reject_first_stage.dart';
import '../widgets/accept_or_reject_request.dart';
import '../widgets/chat/bottom_bar.dart';
import '../widgets/chat/message_widget.dart';
import '../widgets/chat/timer.dart';
import '../widgets/sheets/enter_parent_phone.dart';
import '../widgets/sheets/inform_parent.dart';
import '../widgets/sheets/shariaa_meeting_skipping.dart';

class ChatScreen extends StatelessWidget {
  final int receiverId;
  final String receiverName;
  final int fromHome;

  const ChatScreen({super.key,
    required this.receiverId,
    required this.receiverName,
    required this.fromHome,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatCubit()),
          BlocProvider(
            create: (context) => ChatNotificationCubit(injector<ChatNotificationService>()),
          )
        ],
        child: _ChatScreenBody(
            receiverId: receiverId,
            receiverName: receiverName,
            fromHome: fromHome
        )
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  final int receiverId;
  final int fromHome;
  final String receiverName;

  const _ChatScreenBody({
    required this.receiverId,
    required this.receiverName,
    required this.fromHome,
  });

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {

  // accept / reject
  // Future<void> _executeAcceptRejectReq({
  //   required BuildContext context,
  //   required String path,
  //   required void Function(ChatModel model) onSuccess
  // }) => context.read<ChatCubit>().executeRequest(
  //     requestModel: RequestModel(
  //       receiverId: widget.receiverId.toString(),
  //       fromHome: widget.fromHome.toString(),
  //       matchRequestId: context.read<ChatCubit>().matchRequestId.toString(),
  //     ),
  //     path: path+context.read<ChatCubit>().userRequest!,
  //     onSuccess: onSuccess
  // );

  Future<void> _executeReq({
    required BuildContext context,
    required String path,
    required void Function(ChatModel model) onSuccess
  }) => context.read<ChatCubit>().executeRequest(
      requestModel: RequestModel(
        receiverId: widget.receiverId.toString(),
        fromHome: widget.fromHome.toString(),
        matchRequestId: context.read<ChatCubit>().matchRequestId.toString(),
      ),
      path: path,
      onSuccess: onSuccess
  );

  void _openAcceptanceSheet({
    required String requestId,
    required String requestName,
  }) => WidgetsBinding.instance.addPostFrameCallback(
          (_) => ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: AcceptOrRejectRequestWidget(
              requestName: requestName,
              onAccept: (context) async => _executeReq(
                  context: context,
                  path: ApiConstants.acceptRequest,
                  onSuccess: (chatModel) => Go.back()
              ),
              onReject:(context) async => _executeReq(
                  context: context,
                  path: ApiConstants.rejectRequest,
                  onSuccess: (chatModel) => Go.back()
              ),
            ),
          )
      )
  );

  // make request
  void _makeRequestSheet({
    required String matchReqId,
  }) => WidgetsBinding.instance.addPostFrameCallback(
          (_) => ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: ChooseRequestSheet(
              onConfirm: (context, selectedVal) async {
                await _executeReq(
                  context: context,
                  path: selectedVal.pathToRequest,
                  onSuccess: (chatModel){
                    Go.back();
                    if(selectedVal == LocaleKeys.refuseMoveToNextStage){
                      Go.offAll(const HomeScreen());
                    }
                  }
                );
              },
              titles: [
                LocaleKeys.moveToNextStage,
                LocaleKeys.refuseMoveToNextStage,
                LocaleKeys.requestForExtensionOfPeriod
              ],
            ),
          )
      )
  );


  Widget _upperWidget(ChatModel model){
    final int? timer = model.matchRequest!.timer;
    if(timer.isNotNull && timer.isNotEqualZero){
     return ChatTimerWidget(minutes: model.matchRequest?.timer ?? 5);
   }

    return const SizedBox.shrink();
  }

  Widget? _initBottomBar({
    required UserRequestStatus status,
    required ChatStages stage,
  }){
    if(stage.isNewChat && status.isPending){
      return AcceptOrRejectFirstStageWidget(
        onAccept: (context) async => _executeReq(
          context: context,
          path: ApiConstants.acceptRequest,
          onSuccess: (chatModel) => context.read<ChatCubit>().startChat(
            receiverId: widget.receiverId,
            fromHome: widget.fromHome,
          ),
        ),

        onReject: (context)async => _executeReq(
            context: context,
            path: ApiConstants.rejectRequest,
            onSuccess: (chatModel) =>  Go.offAll(const HomeScreen())
        ),
      );
    }

    return null;
  }



  // 74|WUSv2KY82QB4qAgnY0e24oXkQLQn04v9adtsB2Rt female
  // 67|IAltRLoGm0Ql9H68MjeoF8QYkofLAmWRXWGqcSpv male
  void Function() _manageSuccessState(ChatModel data) {
    final timer = data.matchRequest!.timer;
    final stage = data.matchRequest!.stage!.value?.getCurrentStageAsStagesEnum;
    final userStatus = data.matchRequest!.userRequestStatus!.getUserRequestStatus;
    final matchRequest = data.matchRequest!.userRequest!.getMatchRequest;
    final ShowTips currentTips = data.matchRequest!.tipsPage!.currentStageTips;

    if(!currentTips.isNoPage){
      return (){
        _showTipsSheet(
          title: currentTips.title.currentStageTipsTitle,
          path: currentTips.path,
          onConfirm: (context) async{
            await context.read<ChatCubit>().tipsSeen(
              matchReqId: context.read<ChatCubit>().matchRequestId.toString(),
              onSuccess: (data) => Go.back(),
            );

            if(currentTips.isShariaComplaintMeetingTips){
              ChatSheetManager.show(
                  child: BlocProvider.value(
                    value: context.read<ChatCubit>(),
                    child: ShariaaMeetingSkipping(
                        onSubmit: (context, val) async{
                          if(val == LocaleKeys.moveToNextStage){
                            await _executeReq(
                              context: context,
                              path: ApiConstants.userMoveToNextRequest,
                              onSuccess: (chatModel) => Go.back(),
                            );

                          }else{
                            await _executeReq(
                              context: context,
                              path: ApiConstants.continueStageRequest,
                              onSuccess: (chatModel) => Go.back(),
                            );
                          }
                        }
                    ),
                  )
              );

            }else if(currentTips.isInformParentsTips){
              ChatSheetManager.show(
                  child: BlocProvider.value(
                    value: context.read<ChatCubit>(),
                    child: InformParentSheet(
                        onSubmit: (context, val)async{
                          if(val == LocaleKeys.enterParentPhoneNumber){
                            await _executeReq(
                              context: context,
                              path: ApiConstants.parentMeetingRequest,
                              onSuccess: (chatModel) => Go.back(),
                            );

                          }else if(val == LocaleKeys.requestForADialogueSessionUnderTheSupervisionOfTheApplication){
                            await _executeReq(
                              context: context,
                              path: ApiConstants.adminMeetingRequest,
                              onSuccess: (chatModel) => Go.back(),
                            );
                          }

                          return;
                        }
                    ),
                  )
              );
            }
          }
        );
      };
    }

    else if(!stage!.isNewChat && userStatus.isPending){
      _openAcceptanceSheet(
        requestName: data.matchRequest?.userRequest ?? '',
        requestId: data.matchRequest!.id.toString(),
      );

    }else if((matchRequest.isExtension || matchRequest.isVideoCall || matchRequest.isAdminMeeting)
        && userStatus.isAccepted){
      return (){
        ChatSheetManager.show(
          child: BlocProvider(
            create: (context) => PayRequestCubit(),
            child: BlocProvider.value(
              value: context.read<ChatCubit>(),
              child: PaymentSheet(
                  onPay: (context, payMethod)async => context.read<PayRequestCubit>().pay(
                      path: ApiConstants.payRequest+context.read<ChatCubit>().userRequest!,
                      matchRequestId: data.matchRequest!.id.toString(),
                      paymentMethod: payMethod.name,
                      onSuccess: (url) async{
                        Object? result = '';

                        if(payMethod == PaymentMethod.online){
                          result = await Go.to(SubscriptionScreen(
                            initialUrl: url!,
                            title: LocaleKeys.pay
                          ));
                        }else if(payMethod == PaymentMethod.wallet){
                          result = 'success';
                        }

                        if(result == 'success'){
                          showDefaultBottomSheet(
                              child: const SuccessSheet(
                                isInAuth: false,
                              )
                          );
                        }
                      },
                  ),
              ),
            ),
          ),
        );
      };

    }else if(stage.isInformParents){
      ChatSheetManager.show(
        child: EnterParentPhoneSheet(
            onSubmit: (context, phone){

            }
        ),
      );
    }

    else if(timer.isEqualZero){
      log('timer::: $timer ${timer.isEqualZero}');
      return (){
        _makeRequestSheet(
          matchReqId: data.matchRequest!.id.toString(),
        );
      };

    }else if(matchRequest.isParentMeeting){
      // show parent sheet
    }

    return (){};
  }







  void _showTipsSheet({
    String? title,
    required String path,
    required FutureOr<void> Function(BuildContext context) onConfirm
  }){
    ChatSheetManager.show(
      child: BlocProvider.value(
        value: context.read<ChatCubit>(),
        child: TipsSheet(
            title: title ?? '',
            path: path,
            onConfirm: onConfirm
        ),
      )
    );
  }

  Future<void> _startChat()async{
    await context.read<ChatCubit>().startChat(
        receiverId: widget.receiverId,
        fromHome: widget.fromHome,
        onSuccess: (data) => _manageSuccessState.call(data).call(),
    );
  }

  Future<void> _showBased(RemoteMessage notification)async{
    if((notification.data['action'] as Object?).isNotNull){
      _startChat();
    }
    // التايمر خلص
    // واحد قدم طلب والتاني المفروض يقبل
    // هترن السيرفس تاني في حالة ان الاتنين وافقو علي اي حاجة
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

  void _init() async {
    socketType
      ..initSocket()
      ..initConfig()
      ..connect();
  }

  void _handleInitialState()async{
    _chatController = PagifyController<ChatMessages>();
     await _startChat();
     _init();
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
    return BlocListener<ChatNotificationCubit, ChatNotificationState>(
      listener: (context, state) async =>
          _showBased(state.notification!),
      child: AppScaffold(
        appBarTitle: LocaleKeys.chat,
        isScrollable: false,
        actions: [
          // IconButton(onPressed: (){
          //   log(_chatController.getRandomItem()?.message.body??'');
          //   log(_chatController.getRandomItem()!.sender.isFromMe.toString());
          // }, icon: const Icon(Icons.add)),
          Helpers.zegoService.zegoButton(
            isVideoCall: false,
            icon: const SvgPic(assetName: Assets.svgPhoneIcon),
            invites: [
              ZegoUIKitUser(id: widget.receiverId.toString(), name: widget.receiverName)
            ],
          ),

          BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
              builder: (context, state) => StatusBuilder(
                data: state,
                onSuccess: (data, context) =>
                // context.read<ChatCubit>().currentStage!.value!.getCurrentStageAsStagesEnum.isShariaComplaintMeeting &&
                //     data.matchRequest!.timer.isNotEqualZero ?
                context.read<ChatCubit>().currentStage!.value!.getCurrentStageAsStagesEnum.isShariaComplaintMeeting?
                  Helpers.zegoService.zegoButton(
                    isVideoCall: true,
                    icon: const SvgPic(assetName: Assets.svgVideoCall),
                    invites: [
                      ZegoUIKitUser(id: widget.receiverId.toString(), name: widget.receiverName)
                    ],
                  ) : const SizedBox.shrink(),
              ),
          ),
        ],
        body: Column(
          children: [
            BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
                builder: (context, state) => StatusBuilder(
                    data: state,
                    onSuccess: (data, context) => _upperWidget(data)
                )),
            Expanded(
              child: EasyChat(
                // itemExtent: 60.h,
                controller: _chatController,
                emptyView: const Center(
                  child: NotContainData(),
                ),
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
        bottomBar: BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
            builder: (context, state) =>
                IntrinsicHeight(
                  child: StatusBuilder(
                    data: state,
                    onSuccess: (data, context) =>
                    _initBottomBar(
                        status: state.data.matchRequest!.userRequestStatus!.getUserRequestStatus,
                        stage: state.data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum
                    ) ?? ChatBottomBar(
                        onUpload: (url){
                          socketType.sendMessage(
                              {
                                'room_id' : state.data.room?.id,
                                'body' : url,
                                'type' : 'image'
                              }
                          );
                        },
                        onSend: (context, msg) => socketType.sendMessage(
                          {
                            'body': msg,
                            'type' : 'text',
                            'room_id' : state.data.room?.id,
                          }
                        )
                    ),
                  ),
                )
        ),
      ),
    );
  }
}

class SocketEvents{
  static const String enterChat = 'enter-chat';
  static const String sendMsg = 'send-message';
  static const String exitChat = 'exit-chat';
  static const String receivedMsg = 'message-received';
}