part of 'imports.dart';


class UserStatusAction extends ChatActions{
  final BuildContext context;
  final UserRequestStatus status;
  final MatchRequestEnum matchRequest;
  final RequestModel requestModel;

  UserStatusAction({
    required this.context,
    required this.status,
    required this.matchRequest,
    required this.requestModel,
  });

  @override
  Future<void> call() async{
    if(status.isPending){
      ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: AcceptOrRejectRequestWidget(
              requestName: matchRequest.name,
              onAccept: (context) async => ChatActions.executeReq(
                  context: context,
                  path: ApiConstants.acceptRequest+context.read<ChatCubit>().userRequest!,
                  onSuccess: (chatModel) => Go.back(), requestModel: requestModel
              ),
              onReject:(context) async => ChatActions.executeReq(
                  context: context,
                  path: ApiConstants.rejectRequest+context.read<ChatCubit>().userRequest!,
                  onSuccess: (chatModel) => Go.back(), requestModel: requestModel
              ),
            ),
          )
      );

    }else if((matchRequest.isExtension || matchRequest.isVideoCall || matchRequest.isAdminMeeting)
        && status.isAccepted){
      ChatSheetManager.show(
        child: BlocProvider(
          create: (context) => PayRequestCubit(),
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: PaymentSheet(
              onPay: (context, payMethod)async => context.read<PayRequestCubit>().pay(
                path: ApiConstants.payRequest+context.read<ChatCubit>().userRequest!,
                matchRequestId: matchRequest.id.toString(),
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

                  context.read<ChatCubit>().startChat(
                      requestModel: requestModel
                  );

                  if(result == 'success'){
                    ChatSheetManager.show(
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