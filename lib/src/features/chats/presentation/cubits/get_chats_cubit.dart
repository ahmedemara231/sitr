import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/chat_model.dart';

enum ChatType {
  current,
  completed,
  rejected,
  pending,
  cancelled
}

class GetChatsCubit extends AsyncCubit<List<ChatModel>>{
  GetChatsCubit() : super([]);

  String _getChatType(ChatType chatType){
    switch(chatType){
      case ChatType.current:
        return ApiConstants.currentChats;

      case ChatType.completed:
        return ApiConstants.completedChats;

      case ChatType.rejected:
        return ApiConstants.rejectedChats;

      case ChatType.cancelled:
        return ApiConstants.cancelledChats;

      case ChatType.pending:
        return ApiConstants.pendingChats;
    }
  }

  Future<void> getChat(ChatType chatType)async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: _getChatType(chatType),
            httpRequestType: HttpRequestType.get,
            mapper: (json) => json.map<ChatModel>((e) => ChatModel.fromJson(e)).toList(),
          )
      ),
    );
  }
}