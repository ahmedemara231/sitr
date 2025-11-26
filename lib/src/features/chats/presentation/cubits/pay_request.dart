import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';

class PayRequestCubit extends AsyncCubit<String>{
  PayRequestCubit() : super('');

  Future<void> pay({
    required String path,
    required String matchRequestId,
    required String paymentMethod,
    required Function(String? url) onSuccess,
})async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.post,
            body: {
              'match_request_id' : matchRequestId,
              'payment_method' : paymentMethod,
            },
            mapper: (json) => json['redirect_url'],
          ),
        ),
        onSuccess: (data) => onSuccess.call(data.data)
    );
  }
}