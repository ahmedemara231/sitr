part of 'imports.dart';


class UserStatusAction extends ChatActions{
  final ChatModel data;
  final RequestModel requestModel;

  UserStatusAction({
    required this.data,
    required this.requestModel,
  });

  UserRequestStatus get status => data.matchRequest!.userRequestStatus!.getUserRequestStatusAsEnum;
  MatchRequestEnum get request => data.matchRequest!.userRequest!.getMatchRequestAsEnum;
  ChatStages get stage => data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;
  int get matchReqId => data.matchRequest!.id!;
  String get requestName => data.matchRequest!.requestName!;

  Future<void> _executeReq(BuildContext context, {
    required String path,
    required void Function() onSuccess
  })async{
    await ChatActions.executeReq(
        context: context,
        path: path,
        requestModel: requestModel,
        onSuccess: (chatModel) => onSuccess.call()
    );
  }

  void _showAcceptanceSheet(BuildContext context, void Function() onSuccess){
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: AcceptOrRejectRequestWidget(
              requestName: requestName,
              title: request.isParentIndividualApproval?
              LocaleKeys.doYouAgreeWithThePartner: null,
              onAccept: (context) async => await _executeReq(
                  context,
                  path: ApiConstants.acceptRequest+context.read<ChatCubit>().userRequest!,
                  onSuccess: onSuccess
              ),
              onReject:(context) async => await _executeReq(
                  context,
                  path: ApiConstants.rejectRequest+context.read<ChatCubit>().userRequest!,
                  onSuccess: onSuccess
              )
          ),
        )
    );
  }

  void _fireUpdate(SocketCubit socketCubit) {
    socketCubit.fireShouldUpdate(
      roomId: data.room!.id!,
      matchRequestId: matchReqId,
      receiverId: int.parse(requestModel.receiverId),
    );
  }

  @override
  Future<void> call(BuildContext context) async{
    final socketCubit = context.read<SocketCubit>();

    if(!stage.isNewChat && status.isPending){
      if(stage.isParentsExchangeNumber){
          ChatSheetManager.show(
            child: BlocProvider.value(
              value: context.read<ChatCubit>(),
              child: EnterParentPhoneSheet(
                  onSubmit: (context, phone)async{
                    await context.read<ChatCubit>().parentsExchangeNumbers(parentPhone: phone);
                    _fireUpdate(socketCubit);
                    Go.back();
                  }
              ),
            ),
          );
      }else{
        _showAcceptanceSheet(context, () {
          _fireUpdate(socketCubit);
          request.isParentIndividualApproval ?
          Go.offAll(const HomeScreen()) : Go.back();
        });
      }
    }
    // else if(status.isParentExchangeNumbers){
    //   ChatSheetManager.show(
    //     child: BlocProvider.value(
    //       value: context.read<ChatCubit>(),
    //       child: EnterParentPhoneSheet(
    //           onSubmit: (context, phone)async{
    //             await context.read<ChatCubit>().parentsExchangeNumbers(parentPhone: phone);
    //             Go.back();
    //           }
    //       ),
    //     ),
    //   );
    //
    // }
    else if(status.isAccepted){
      final chatCubit = context.read<ChatCubit>();
      final userRequest = chatCubit.userRequest!;

      if(stage.isCompleted){
        ChatSheetManager.show(
          child: BlocProvider.value(
            value: chatCubit,
            child: ParentIndividualCongratsSheet(
              matchReqId: matchReqId,
              onTap: () {
                2.pop();
                Go.to(ParentDetailsScreen(id: data.room!.members!.first.id??0));
              }
            )
          ),
        );

      }else{
        ChatSheetManager.show(
          child: BlocProvider.value(
            value: chatCubit,
            child: BlocProvider(
              create: (context) => PayRequestCubit(),
              child: PaymentSheet(
                onPay: (ctx, payMethod)async {
                  final payRequestCubit = ctx.read<PayRequestCubit>();
                  if(payMethod == PaymentMethod.online) {
                    ChatSheetManager.show(
                        child: ShowBrandsSheet(
                          onPay: (_, brandId) => payRequestCubit.pay(
                            path: ApiConstants.payRequest + userRequest,
                            matchRequestId: matchReqId.toString(),
                            paymentMethod: payMethod.name,
                            brandId: brandId,
                            onSuccess: (url) async{
                              Object? result = '';
                              result = await Go.to(SubscriptionScreen(
                                  initialUrl: url!,
                                  title: LocaleKeys.pay
                              ));

                              if(result == 'success'){
                                _fireUpdate(socketCubit);
                                chatCubit.startChat(
                                  requestModel: requestModel,
                                  context: context,
                                );

                                ChatSheetManager.show(
                                    child: SuccessSheet(
                                      isInAuth: false,
                                      upperText: Column(
                                        spacing: 10.h,
                                        children: [
                                          AppText(LocaleKeys.paymentSucceeded),
                                          AppText(LocaleKeys.youCanNowContinueChatStages, color: Colors.grey, fontSize: 12.sp),
                                        ],
                                      ),
                                    )
                                );
                              }
                            },
                          ),
                        )
                    );
                  } else {
                    await payRequestCubit.pay(
                      path: ApiConstants.payRequest + userRequest,
                      matchRequestId: matchReqId.toString(),
                      paymentMethod: payMethod.name,
                      onSuccess: (url) async{
                        _fireUpdate(socketCubit);
                        chatCubit.startChat(
                          requestModel: requestModel,
                          context: context,
                        );

                        ChatSheetManager.show(
                            child: SuccessSheet(
                              isInAuth: false,
                              upperText: Column(
                                spacing: 10.h,
                                children: [
                                  AppText(LocaleKeys.paymentSucceeded),
                                  AppText(LocaleKeys.youCanNowContinueChatStages, color: Colors.grey, fontSize: 12.sp),
                                ],
                              ),
                            )
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      }

    }else if(status.isParentMeeting){
      ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: InformParentSheet(
                onSubmit: (context, val)async{
                  String path = ApiConstants.matchRequestAnd;
                  if(val == LocaleKeys.enterParentPhoneNumber){
                    path = path+ApiConstants.parentMeetingRequest;

                  }else if(val == LocaleKeys.requestForADialogueSessionUnderTheSupervisionOfTheApplication){
                    path = path+ApiConstants.adminMeetingRequest;

                  }

                  await ChatActions.executeReq(
                    context: context,
                    path: path,
                    requestModel: requestModel,
                    onSuccess: (chatModel) {
                      _fireUpdate(socketCubit);
                      Go.back();
                    },
                  );

                  return;
                }
            ),
          )
      );
    }
  }
}