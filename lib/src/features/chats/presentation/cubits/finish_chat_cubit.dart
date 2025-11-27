import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class CongratsCubit extends AsyncCubit{
  CongratsCubit() : super(null);

  Future<void> finishChat(int matchReqId)async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.finishChat,
            httpRequestType: HttpRequestType.post,
            body: {
              'match_request_id' : matchReqId
            }
          )
      ),
    );
  }
}