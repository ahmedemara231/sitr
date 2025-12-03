part of 'imports.dart';


class UserStatusAction extends ChatActions{
  final BuildContext context;
  final UserRequestStatus status;
  final MatchRequestEnum request;
  final ChatStages stage;
  final int matchReqId;
  final RequestModel requestModel;

  UserStatusAction({
    required this.matchReqId,
    required this.stage,
    required this.context,
    required this.status,
    required this.request,
    required this.requestModel,
  });

  // void _finishChat(BuildContext context){
  //   context.read<FinishChatCubit>().finishChat(matchReqId);
  // }

  void _showAcceptanceSheet(void Function() onSuccess){
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: AcceptOrRejectRequestWidget(
            requestName: request.name,
            onAccept: (context) async => ChatActions.executeReq(
                context: context,
                path: ApiConstants.acceptRequest+context.read<ChatCubit>().userRequest!,
                requestModel: requestModel,
                onSuccess: (chatModel) => onSuccess.call()
            ),
            onReject:(context) async => ChatActions.executeReq(
                context: context,
                path: ApiConstants.rejectRequest+context.read<ChatCubit>().userRequest!,
                requestModel: requestModel,
                onSuccess: (chatModel) => onSuccess.call()
            ),
          ),
        )
    );
  }

  @override
  Future<void> call() async{
    if(!stage.isNewChat && status.isPending){
      _showAcceptanceSheet(
            () => request.isParentIndividualApproval?
            Go.offAll(const HomeScreen()) : Go.back(),
      );

    }else if((request.isExtension || request.isVideoCall || request.isAdminMeeting)
        && status.isAccepted){
      ChatSheetManager.show(
        child: BlocProvider(
          create: (context) => PayRequestCubit(),
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: PaymentSheet(
              onPay: (context, payMethod)async => context.read<PayRequestCubit>().pay(
                path: ApiConstants.payRequest+context.read<ChatCubit>().userRequest!,
                matchRequestId: matchReqId.toString(),
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
                    context.read<ChatCubit>().startChat(
                        requestModel: requestModel
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
            ),
          ),
        ),
      );

    }else if(status.isParentMeeting){
      ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: InformParentSheet(
                onSubmit: (context, val)async{
                  if(val == LocaleKeys.enterParentPhoneNumber){
                    await ChatActions.executeReq(
                      context: context,
                      path: ApiConstants.parentMeetingRequest,
                      requestModel: requestModel,
                      onSuccess: (chatModel) => Go.back(),
                    );

                  }else if(val == LocaleKeys.requestForADialogueSessionUnderTheSupervisionOfTheApplication){
                    await ChatActions.executeReq(
                      context: context,
                      path: ApiConstants.adminMeetingRequest,
                      requestModel: requestModel,
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
}