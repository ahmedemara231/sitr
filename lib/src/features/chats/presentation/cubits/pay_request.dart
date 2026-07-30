import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../config/res/config_imports.dart';

class PayRequestCubit extends AsyncCubit<String>{
  PayRequestCubit() : super('');

  Future<void> pay({
    required String path,
    required String matchRequestId,
    required String paymentMethod,
    int? brandId,
    required Function(String? url) onSuccess,
})async{
    if (FeatureFlags.removeWallet && paymentMethod == 'wallet') return;
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.post,
            body: {
              'brand_id' : brandId,
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
