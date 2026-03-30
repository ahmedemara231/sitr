import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/models/chat_model.dart';

enum ChatType {
  current(0),
  completed(1),
  rejected(2),
  cancelled(3),
  pending(4);

  final int i;
  const ChatType(this.i);
}

extension ConvertToChatType on String{
  ChatType get getChatType{
    switch(this){
      case 'current':
        return ChatType.current;

      case 'completed':
        return ChatType.completed;

      case 'rejected':
        return ChatType.rejected;

      case 'cancelled':
        return ChatType.cancelled;

      case 'pending':
        return ChatType.pending;

      default:
        return ChatType.current;
    }
  }
}

extension Check on ChatType{
  bool get isCurrent => this == ChatType.current;
  bool get isCompleted => this == ChatType.completed;
  bool get isRejected => this == ChatType.rejected;
  bool get isCancelled => this == ChatType.cancelled;
}

class GetChatsCubit extends AsyncCubit<List<ChatModel>>{
  GetChatsCubit() : super([]);

  void resetUnreadMessagesCount(int i){
    final updatedChat = state.data[i].copyWith(
      room: state.data[i].room!.copyWith(unreadMsgs: 0),
    );
    final newList = List<ChatModel>.from(state.data)..[i] = updatedChat;
    emit(state.copyWith(status: BaseStatus.success, data: newList));
  }

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
            cacheKey: 'chats_${chatType.name}',
            httpRequestType: HttpRequestType.get,
            mapper: (json) => (json as List)
                .map<ChatModel>((e) => ChatModel.fromJson(e))
                .toList(),
            fromCacheJson: (json) => (json['data'] as List)
                .map<ChatModel>((e) => ChatModel.fromJson(e))
                .toList(),
            toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
          )
      ),
    );
  }
}