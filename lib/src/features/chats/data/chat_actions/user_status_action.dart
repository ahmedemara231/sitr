part of 'imports.dart';


class UserStatusAction extends ChatActions{
  final BuildContext context;
  final UserRequestStatus status;
  final MatchRequestEnum request;
  final ChatStages stage;
  final int matchReqId;
  final RequestModel requestModel;
  final String requestName;

  UserStatusAction({
    required this.matchReqId,
    required this.stage,
    required this.context,
    required this.status,
    required this.request,
    required this.requestName,
    required this.requestModel,
  });

  Future<void> _executeReq(BuildContext context,{
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

  void _showAcceptanceSheet(void Function() onSuccess){
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: AcceptOrRejectRequestWidget(
              requestName: requestName,
              onAccept: (context) async => await _executeReq(
                  context, path: ApiConstants.acceptRequest+context.read<ChatCubit>().userRequest!,
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

  @override
  Future<void> call() async{
    if(!stage.isNewChat && status.isPending){
      _showAcceptanceSheet(
            () => request.isParentIndividualApproval?
        Go.offAll(const HomeScreen()) : Go.back(),
      );

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
    else if((request.isExtension || request.isVideoCall || request.isAdminMeeting)
        && status.isAccepted){
      final chatCubit = context.read<ChatCubit>();
      final userRequest = chatCubit.userRequest!;

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
                            chatCubit.startChat(
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
                    )
                  );
                } else {
                  await payRequestCubit.pay(
                    path: ApiConstants.payRequest + userRequest,
                    matchRequestId: matchReqId.toString(),
                    paymentMethod: payMethod.name,
                    onSuccess: (url) async{
                      chatCubit.startChat(
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
                    },
                  );
                }
              },
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
                    onSuccess: (chatModel) => Go.back(),
                  );

                  return;
                }
            ),
          )
      );
    }
  }
}