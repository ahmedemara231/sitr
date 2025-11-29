part of 'imports.dart';

class StageAction extends ChatActions{
  final BuildContext context;
  final ChatStages stage;

  StageAction({
    required this.context,
    required this.stage,
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
    }
  }

}