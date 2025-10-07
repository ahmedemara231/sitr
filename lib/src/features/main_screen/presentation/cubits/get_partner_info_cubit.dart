import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class GetPartnerInfoCubit extends AsyncCubit<UserModel>{
  GetPartnerInfoCubit() : super(UserModel.initial());

  Future<void> getPartnerInfoData(int id, {required void Function(UserModel user) onSuccess})async{
    executeAsync(
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.getPartnerInfo+id.toString(),
            httpRequestType: HttpRequestType.get,
            mapper: (json) => UserModel.fromJson(json),
          ),
      ),

      successEmitter: (data) => onSuccess.call(data)
    );
  }

}