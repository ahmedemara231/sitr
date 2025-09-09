import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class SubscribePackageCubit extends AsyncCubit{
  SubscribePackageCubit() : super('');

  Future<void> subscribePackage({
    required String packageId,
    required String paymentMethod,
    void Function()? onSuccess
  })async{
    setLoading();
    await executeAsync(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.subscribePackage,
                httpRequestType: HttpRequestType.post,
                body: {
                  'package_id': packageId,
                  'payment_method': paymentMethod
                },
                mapper: (data) => ''
            )
        ),
        successEmitter: (data) => onSuccess?.call()
    );
  }

}