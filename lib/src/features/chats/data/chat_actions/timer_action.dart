part of 'imports.dart';

class TimerAction extends ChatActions{
  final BuildContext context;
  final RequestModel requestModel;

  TimerAction({
    required this.context,
    required this.requestModel,
  });

  @override
  Future<void> call() async{
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
              LocaleKeys.requestForExtensionOfPeriod
            ],
          ),
        )
    );
  }
}
