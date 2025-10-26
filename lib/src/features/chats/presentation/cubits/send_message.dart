import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class SendMsgCubit extends AsyncCubit{
  SendMsgCubit() : super(null);

  Future<void> sendMsg(int roomId)async{
    await executeAsync(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.sendMsg+roomId.toString(),
            httpRequestType: HttpRequestType.post,
          )
      ),
    );
  }
}