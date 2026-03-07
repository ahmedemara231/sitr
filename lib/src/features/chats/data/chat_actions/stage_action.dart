part of 'imports.dart';

class StageAction extends ChatActions{
  final BuildContext context;
  final ChatStages stage;
  final RequestModel requestModel;

  StageAction({
    required this.context,
    required this.stage,
    required this.requestModel
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
                  String path = ApiConstants.matchRequestAnd;
                  if (val == LocaleKeys.moveToNextStage) {
                    path = path + ApiConstants.userMoveToNextRequest;
                  } else {
                    path = path + ApiConstants.continueStageRequest;
                  }

                  await ChatActions.executeReq(
                    context: context,
                    path: path,
                    onSuccess: (chatModel) => Go.back(),
                    requestModel: requestModel,
                  );
                }
            ),
          )
      );
    }
  }
}