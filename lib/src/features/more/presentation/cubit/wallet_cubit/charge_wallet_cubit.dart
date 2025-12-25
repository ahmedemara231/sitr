import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../core/widgets/custom_messages.dart';

class ChargeWalletCubit extends AsyncCubit<String>{
  ChargeWalletCubit() : super('');

  Future<void> chargeWallet(String amount, {required void Function(String url) onSuccess})async{
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.chargeWallet,
            httpRequestType: HttpRequestType.post,
            body: {'amount' : amount},
            mapper: (data) => data['redirect_url'],
          )
      ),
      onSuccess: (data) => onSuccess.call(data.data)
    );
  }

}