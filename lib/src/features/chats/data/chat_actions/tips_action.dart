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
    required FutureOr<void> Function() onConfirm
  }){
    ChatSheetManager.show(
        child: BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: TipsSheet(
            path: path,
            onConfirm: ()async{
              await onConfirm.call();
              await context.read<ChatCubit>().tipsSeen();
              await context.read<ChatCubit>().startChat(requestModel: requestModel, context: context);
            },
            btnTitle: btnTitle,
          ),
        ),
    );
  }

  @override
  Future<void> call() async {
    showTipsSheet(
        context,
        path: currentTips.path,
        btnTitle: currentTips.isChattingStageTips?
        LocaleKeys.start : null,
        onConfirm: () async{
          if(currentTips.isEngagementTips){
            await ChatSheetManager.show(
                child: CongratsSheet(
                    matchReqId: context.read<ChatCubit>().matchRequestId!
                )
            );

            Go.offAll(const HomeScreen());

          }else{
            Go.back();
          }
          // if(currentTips.isInformParentsTips){
          //   ChatSheetManager.show(
          //       child: BlocProvider.value(
          //         value: context.read<ChatCubit>(),
          //         child: InformParentSheet(
          //             onSubmit: (context, val)async{
          //               String path = ApiConstants.matchRequestAnd;
          //               if(val == LocaleKeys.enterParentPhoneNumber){
          //                 path = path+ApiConstants.parentMeetingRequest;
          //
          //               }else{
          //                 path = path+ApiConstants.adminMeetingRequest;
          //               }
          //
          //               await ChatActions.executeReq(
          //                 context: context,
          //                 path: path,
          //                 requestModel: requestModel,
          //                 onSuccess: (chatModel) => Go.back(),
          //               );
          //
          //               return;
          //             }
          //         ),
          //       )
          //   );
          //
          // }
        }
    );
  }
}