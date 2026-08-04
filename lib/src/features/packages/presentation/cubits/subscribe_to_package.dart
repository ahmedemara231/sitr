import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../models/package.dart';
import '../models/package_screen_type.dart';

class PackagesManagerCubit extends AsyncCubit<String>{
  PackagesManagerCubit() : super('');

  Future<void> subscribeOrRenewPackage({
    required Package package,
    required PaymentMethod paymentMethod,
    required ScreenType type,
    void Function(String url)? onSuccess,
    final int? brandId,
  })async{
    if (FeatureFlags.removeWallet &&
        paymentMethod == PaymentMethod.wallet) {
      return;
    }
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: type == ScreenType.subscription?
                ApiConstants.subscribePackage :
                ApiConstants.renewPackage,

                httpRequestType: HttpRequestType.post,
                body: {
                  'brand_id' : brandId,
                  if(type == ScreenType.renew)
                    'user_package_id' : package.id,

                  'package_id': type == ScreenType.renew?
                  package.packageId : package.id,
                  'payment_method': paymentMethod.name,
                },

                mapper: (data) => paymentMethod == PaymentMethod.online?
                data['redirect_url'] : ''
            )
        ),
        onSuccess: (data) => onSuccess?.call(data.data)
    );
  }

}
