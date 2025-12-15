import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class EndVideoCallCubit extends AsyncCubit{
  EndVideoCallCubit() : super(null);

  static EndVideoCallCubit get instance => injector<EndVideoCallCubit>();

  Future<void> endVideoCall(String matchReqId)async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
              api: ApiConstants.endVideoCall,
              httpRequestType: HttpRequestType.post,
              body: {
                'match_request_id' : matchReqId
              }
          )
      ),
    );
  }
}