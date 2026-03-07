part of 'imports.dart';

class StageAction extends ChatActions{
  final BuildContext context;
  final ChatStages stage;
  final RequestModel requestModel;
  final int timer;

  StageAction({
    required this.context,
    required this.stage,
    required this.requestModel,
    required this.timer,
  });

  @override
  Future<void> call() async{
    if(stage.isParentsExchangeNumber){
      ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: EnterParentPhoneSheet(
              onSubmit: (context, phone)async{
                await context.read<ChatCubit>().parentsExchangeNumbers(parentPhone: phone);
                Go.back();
              }
          ),
        ),
      );

    }else if(stage.isShariaMeetingChoice){
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
                    onSuccess: (chatModel) => Go.back(),
                    requestModel: requestModel,
                  );
                }
            ),
          )
      );

    }else if(timer.isEqualZero){
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