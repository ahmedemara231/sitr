import '../../../../../config/res/config_imports.dart' show injector;
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../models/block_user_model.dart';

class FetchBlockUserCubit extends AsyncCubit<List<BlockUserModel>>{
  FetchBlockUserCubit():super([]);
  Future<void> fetchBlockUser() async {
    await executeAsync(
        operation: () async => await baseCrudUseCase
            .call<List<BlockUserModel>>(CrudBaseParmas(
          api: ApiConstants.blockUser,
          httpRequestType: HttpRequestType.get,
          mapper: (data) {
            final list = data['data']
                .map<BlockUserModel>(
                    (e) => BlockUserModel.fromJson(e))
                .toList();
            return list;
          },
        )));
  }


  void removeItemById(int id){
    final updatedList=state.data.where((element) => element.id!=id).toList();
    setSuccess(data: updatedList);
  }
}