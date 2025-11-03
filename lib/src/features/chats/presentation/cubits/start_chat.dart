import 'dart:async';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/request_model.dart';
import '../../enums.dart';

class ChatCubit extends AsyncCubit<ChatModel>{
  ChatCubit() : super(ChatModel());

  Stage? get currentStage => state.data.matchRequest?.stage;
  ChatStages? get currentStageAsEnum => state.data.matchRequest?.stage?.value?.getCurrentStageAsStagesEnum;

  String? get userRequest => state.data.matchRequest?.userRequest;
  MatchRequestEnum? get userRequestAsEnum => state.data.matchRequest?.userRequest?.getMatchRequest;

  String? get userRequestStatus => state.data.matchRequest?.userRequestStatus;
  UserRequestStatus? get userRequestStatusAsEnum => state.data.matchRequest?.userRequestStatus?.getUserRequestStatus;

  int? get matchRequestId => state.data.matchRequest?.id;


  Future<void> executeRequest({
    required RequestModel requestModel,
    required String path,
    required FutureOr<void> Function(ChatModel model) onSuccess,
  })async{
    await executeAsync(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.post,
            body: requestModel.toJson(),
            mapper: (json) => ChatModel.fromJson(json),
          ),
        ),
        successEmitter: (data) => onSuccess.call(data)
    );
  }

  Future<void> startChat({
    required int receiverId,
    required int fromHome,
    void Function(ChatModel chatModel)? onSuccess
})async{
    await Helpers.initZegoService();
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
      successEmitter: (data) => onSuccess?.call(data)
    );
  }
}