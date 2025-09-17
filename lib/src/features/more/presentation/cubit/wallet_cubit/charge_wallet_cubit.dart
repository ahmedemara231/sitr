import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../core/widgets/custom_messages.dart';

class ChargeWalletCubit extends AsyncCubit<bool>{
  ChargeWalletCubit() : super(false);

  Future<void> chargeWallet(double amount)async{

    await executeAsync(
      operation: () async => await baseCrudUseCase.call(

          CrudBaseParmas(
            api: ApiConstants.chargeWallet,
            httpRequestType: HttpRequestType.post,
            body: {'amount':amount,},
            mapper: (data)=>true,
          )
      ),
      successEmitter: (data){
        MessageUtils.showSnackBar(LocaleKeys.successDone);
        Go.back();
      }
    );
  }

}