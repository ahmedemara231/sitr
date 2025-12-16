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
    required String path,
    String? btnTitle,
    required FutureOr<void> Function(BuildContext context) onConfirm
  }){
    context.read<ChatCubit>().tipsSeen();
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: TipsSheet(
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
                        String path = ApiConstants.matchRequestAnd;
                        if(val == LocaleKeys.moveToNextStage){
                          path = path+ApiConstants.userMoveToNextRequest;

                        }else{
                          path = path+ApiConstants.continueStageRequest;
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

          }else if(currentTips.isIstikharahTips){
            ChatSheetManager.show(
                child: BlocProvider.value(
                  value: context.read<ChatCubit>(),
                  child: const IstikharahReminderSheet(),
                )
            );

          }else if(currentTips.isInformParentsTips){
            ChatSheetManager.show(
                child: BlocProvider.value(
                  value: context.read<ChatCubit>(),
                  child: InformParentSheet(
                      onSubmit: (context, val)async{
                        String path = ApiConstants.matchRequestAnd;
                        if(val == LocaleKeys.enterParentPhoneNumber){
                          path = path+ApiConstants.parentMeetingRequest;

                        }else{
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