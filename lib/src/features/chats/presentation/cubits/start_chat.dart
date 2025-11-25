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

  MatchRequest? get matchRequest => state.data.matchRequest;
  Stage? get currentStage => matchRequest?.stage;
  String? get userRequest => matchRequest?.userRequest;
  MatchRequestEnum? get userRequestAsEnum => matchRequest?.userRequest?.getMatchRequestAsEnum;

  String? get userRequestStatus => matchRequest?.userRequestStatus;
  UserRequestStatus? get userRequestStatusAsEnum => matchRequest?.userRequestStatus?.getUserRequestStatusAsEnum;

  int? get matchRequestId => matchRequest?.id;

  ChatStages? get currentStageAsEnum => currentStage?.value?.getCurrentStageAsStagesEnum;

  Room? get currentRoom => state.data.room;


  Future<void> executeRequest({
    required RequestModel requestModel,
    required String path,
    required FutureOr<void> Function(ChatModel model) onSuccess,
  })async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.post,
            body: requestModel.toJson(),
            mapper: (json) => ChatModel.fromJson(json),
          ),
        ),
        successEmitter: (data) => onSuccess.call(data.data)
    );
  }

  Future<void> startChat({
    required int receiverId,
    required int fromHome,
    void Function(ChatModel chatModel)? onSuccess
})async{
    await Helpers.initZegoService();
    await executeAsyncWithBaseModel(
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
      successEmitter: (data) => onSuccess?.call(data.data)
    );
  }

  Future<void> tipsSeen({
    required String matchReqId,
  })async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.matchTipPageSeen,
            httpRequestType: HttpRequestType.post,
            body: {
              "match_request_id" : matchReqId,
            },
            mapper: (json) => ChatModel.fromJson(json),
          ),
        ),
    );
  }
}