part of 'imports.dart';

class TipsAction extends ChatActions{
  final BuildContext context;
  final ShowTips currentTips;
  RequestModel requestModel;

  TipsAction({
    required this.context,
    required this.currentTips,
    required this.requestModel,
  });

  void showTipsSheet(BuildContext context, {
    String? title,
    required String path,
    String? btnTitle,
    required FutureOr<void> Function(BuildContext context) onConfirm
  }){
    context.read<ChatCubit>().tipsSeen();
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: TipsSheet(
            title: title ?? '',
            path: path,
            onConfirm: onConfirm,
            btnTitle: btnTitle,
          ),
        )
    );
  }

  @override
  Future<void> call() async {
    showTipsSheet(
        context,
        title: currentTips.title.currentStageTipsTitle,
        path: currentTips.path,
        btnTitle: currentTips.isChattingStageTips?
        LocaleKeys.start : null,
        onConfirm: (context) async{
          if(currentTips.isShariaComplaintMeetingTerms){
            ChatSheetManager.show(
                child: BlocProvider.value(
                  value: context.read<ChatCubit>(),
                  child: ShariaaMeetingSkipping(
                      onSubmit: (context, val) async{
                        if(val == LocaleKeys.moveToNextStage){
                          await ChatActions.executeReq(
                            context: context,
                            path: ApiConstants.userMoveToNextRequest,
                            onSuccess: (chatModel) => Go.back(),
                            requestModel: requestModel,
                          );

                        }else{
                          await ChatActions.executeReq(
                            context: context,
                            path: ApiConstants.continueStageRequest,
                            onSuccess: (chatModel) => Go.back(),
                            requestModel: requestModel,
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

          }else if(currentTips.isEngagementTips){
            ChatSheetManager.show(
                child: CongratsSheet(
                    matchReqId: context.read<ChatCubit>().matchRequestId!
                )
            );

          }else{
            Go.back();
          }
        }
    );
  }
}