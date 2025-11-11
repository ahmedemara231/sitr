import '../../../../../config/res/config_imports.dart' show injector;
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../models/block_user_model.dart';

class UnBlockUserCubit extends AsyncCubit{
  UnBlockUserCubit():super(false);
  Future<void> unblockUser({required int userId, Function(dynamic)? function})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(CrudBaseParmas(
          api: '${ApiConstants.unBlockUser}$userId',
          httpRequestType: HttpRequestType.delete,
          mapper: (data)=>true,
        )),
        successEmitter: (data) => function?.call(data)
    );
  }
}