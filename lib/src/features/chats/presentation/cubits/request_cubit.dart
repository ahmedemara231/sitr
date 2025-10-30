import 'dart:async';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/request_model.dart';

class RequestCubit extends AsyncCubit{
  RequestCubit() : super(null);

  Future<void> executeRequest({
    required RequestModel requestModel,
    required String path,
    required FutureOr<void> Function() onSuccess,
})async{
    await executeAsync(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: path,
          httpRequestType: HttpRequestType.post,
          body: requestModel.toJson()
        ),
      ),
      successEmitter: (data) => onSuccess.call()
    );
  }
}