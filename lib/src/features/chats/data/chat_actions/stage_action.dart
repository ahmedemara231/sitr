part of 'imports.dart';

class StageAction extends ChatActions{
  final ChatModel data;
  final RequestModel requestModel;

  StageAction({
    required this.data,
    required this.requestModel,
  });

  ChatStages get stage => data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;
  bool get hasSentRequest => data.matchRequest!.hasSendRequest ?? false;
  int get timer => data.matchRequest!.timer!;

  void _fireUpdate(SocketCubit socketCubit) {
    socketCubit.fireShouldUpdate(
      roomId: data.room!.id!,
      matchRequestId: data.matchRequest!.id!,
      receiverId: int.parse(requestModel.receiverId),
    );
  }

  @override
  Future<void> call(BuildContext context) async{
    final socketCubit = context.read<SocketCubit>();

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

    }else
      if(stage.isShariaMeetingChoice){
      ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: ShariaaMeetingSkipping(
                onSubmit: (context, val) async {
                  late ShariaChoice choice;
                  // String path = ApiConstants.matchRequestAnd;
                  if (val == LocaleKeys.moveToNextStage) {
                    choice = ShariaChoice.skip;
                    // path = path + ApiConstants.userMoveToNextRequest;
                  } else {
                    choice = ShariaChoice.complete;
                    // path = path + ApiConstants.continueStageRequest;
                  }

                  await ChatActions.executeReq(
                    context: context,
                    path: ApiConstants.matchRequestAnd + ApiConstants.shariaChoiceRequest,
                    additionalBody: {'choice': choice.value},
                    onSuccess: (chatModel) {
                      _fireUpdate(socketCubit);
                      Go.back();
                    },
                    requestModel: requestModel,
                  );
                }
            ),
          )
      );

    }else if(timer.isEqualZero && !hasSentRequest){
      ChatSheetManager.show(
          child: BlocProvider.value(
            value: context.read<ChatCubit>(),
            child: ChooseRequestSheet(
              onConfirm: (context, selectedVal) async {
                await ChatActions.executeReq(
                  context: context,
                  requestModel: requestModel,
                  path: selectedVal.pathToRequest,
                  onSuccess: (chatModel){
                    _fireUpdate(socketCubit);
                    Go.back();
                    if(selectedVal == LocaleKeys.refuseMoveToNextStage){
                      Go.offAll(const HomeScreen());
                    }
                  },
                );
              },
              titles: [
                LocaleKeys.moveToNextStage,
                LocaleKeys.refuseMoveToNextStage,
                if(!stage.isShariaComplaintMeeting)
                  LocaleKeys.requestForExtensionOfPeriod
              ],
            ),
          )
      );

    }else{
      return;
    }
  }
}