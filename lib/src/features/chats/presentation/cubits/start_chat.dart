import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/chat_model.dart';
import '../../enums.dart';

class StartChatCubit extends AsyncCubit<ChatModel>{
  StartChatCubit() : super(ChatModel());

  Future<void> startChat({
    required int receiverId,
    required int fromHome,
    required void Function(ChatStages chatCurrentStage) onSuccess
})async{
    await executeAsync(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.startChat,
            httpRequestType: HttpRequestType.post,
            body: {
              "receiver_id": receiverId,
              "from_home": fromHome,
            },
            mapper: (json) => ChatModel.fromJson(json),
          ),
      ),
      successEmitter: (data) =>
          onSuccess.call(data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum)
    );
  }
}