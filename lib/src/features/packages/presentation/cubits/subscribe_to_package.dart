import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../packages_screen.dart';

class PackagesManagerCubit extends AsyncCubit<String>{
  PackagesManagerCubit() : super('');

  Future<void> subscribeOrRenewPackage({
    required String packageId,
    required PaymentMethod paymentMethod,
    required ScreenType type,
    void Function(String url)? onSuccess
  })async{
    setLoading();
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: type == ScreenType.first?
                ApiConstants.subscribePackage :
                ApiConstants.renewPackage,

                httpRequestType: HttpRequestType.post,
                body: {
                  'package_id': packageId,
                  'payment_method': paymentMethod.name
                },

                mapper: (data) => paymentMethod == PaymentMethod.online?
                data['redirect_url'] : ''
            )
        ),
        successEmitter: (data) => onSuccess?.call(data.data)
    );
  }

}