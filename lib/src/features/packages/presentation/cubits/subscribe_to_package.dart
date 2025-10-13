import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../packages_screen.dart';

class SubscribePackageCubit extends AsyncCubit<String>{
  SubscribePackageCubit() : super('');

  Future<void> subscribeOrRenewPackage({
    required String packageId,
    required ScreenType type,
    required String paymentMethod,
    void Function(String url)? onSuccess
  })async{
    setLoading();
    await executeAsync(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: type == ScreenType.view?
                ApiConstants.subscribePackage :
                ApiConstants.renewPackage,
                httpRequestType: HttpRequestType.post,
                body: {
                  'package_id': packageId,
                  'payment_method': paymentMethod
                },
                mapper: (data) => data['redirect_url']
            )
        ),
        successEmitter: (data) => onSuccess?.call(data)
    );
  }

}