import 'dart:async';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/request_model.dart';

class CheckChatEligibilityCubit extends AsyncCubit<CanChat> {
  CheckChatEligibilityCubit({required CanChat initialCanChat})
      : super(initialCanChat);

  Future<void> checkEligibility({
    required RequestModel requestModel,
    required FutureOr<void> Function(ChatModel chatModel) onEligible,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call<CanChat>(
        CrudBaseParmas<CanChat>(
          api: ApiConstants.checkChatEligibility,
          httpRequestType: HttpRequestType.post,
          body: requestModel.toJson(),
          mapper: (json) => CanChat.fromJson(json),
        ),
      ),
      onSuccess: (data) async {
        if (!data.data.canChat) return;
        final ChatModel? chatModel = await _startChat(requestModel);
        if (chatModel != null) await onEligible(chatModel);
      },
    );
  }

  Future<ChatModel?> _startChat(RequestModel requestModel) async {
    final result = await baseCrudUseCase.call<ChatModel>(
      CrudBaseParmas<ChatModel>(
        api: ApiConstants.startChat,
        httpRequestType: HttpRequestType.post,
        cacheKey: 'chat_${requestModel.receiverId}',
        body: requestModel.toJson(),
        mapper: (json) => ChatModel.fromJson(json),
        toJson: (model) => model.toJson(),
      ),
    );

    ChatModel? chatModel;
    result.when(
      (success) => chatModel = success.data,
      (failure) {
        MessageUtils.showTopMsg(failure.message);
        setError(errorMessage: failure.message);
      },
    );
    return chatModel;
  }

  void markChatRequestSent() => updateData(
        const CanChat(
          canChat: false,
          reason: ChatReason.chatRequestSent,
        ),
      );
}
