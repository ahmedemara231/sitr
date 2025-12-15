import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/chat_model.dart';

class EndVideoCallCubit extends AsyncCubit<ChatModel>{
  EndVideoCallCubit() : super(ChatModel());

  static EndVideoCallCubit get instance => injector<EndVideoCallCubit>();

  Future<void> endVideoCall(String matchReqId)async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
              api: ApiConstants.endVideoCall,
              httpRequestType: HttpRequestType.post,
              mapper: (json) => ChatModel.fromJson(json),
              body: {
                'match_request_id' : matchReqId
              }
          )
      ),
    );
  }
}