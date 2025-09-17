import '../../../../../config/res/config_imports.dart' show injector;
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../models/block_user_model.dart';

class UnBlockUserCubit extends AsyncCubit{
  UnBlockUserCubit():super(false){
    injector<NetworkService>()
        .setToken('Bearer 138|iKDgQ2TE1R0m4DQIOkD6NtMd6LFVnMv9Q3aS0NCk');
  }
  Future<void> unblockUser({required int userId,required  Function(dynamic) function  })async{
    await executeAsync(
        operation: () async => await baseCrudUseCase
            .call(CrudBaseParmas(
          api: '${ApiConstants.unBlockUser}$userId',
          httpRequestType: HttpRequestType.delete,
          mapper: (data)=>true,
        )),successEmitter: function);

  }




}