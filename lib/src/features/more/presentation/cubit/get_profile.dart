import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/convert_user_model_to_data_list_cubit.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class GetProfileCubit extends GetUserModelCubit{
  @override
  Future<void> getUserModelData({required void Function(UserModel data) onSuccess})async {
    executeAsync(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.profile,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => UserModel.fromJson(json),
          ),
      ),
      successEmitter: (user) => onSuccess.call(user)
    );
  }

}