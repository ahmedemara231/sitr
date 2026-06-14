import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/convert_user_model_to_data_list_cubit.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class GetPartnerInfoCubit extends GetUserModelCubit{
  final int id;
  GetPartnerInfoCubit(this.id);

  @override
  Future<void> getProfile({void Function(UserModel data)? onSuccess})async {
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.getPartnerInfo+id.toString(),
            httpRequestType: HttpRequestType.get,
            cacheKey: 'partner_info_$id',
            mapper: (json) => UserModel.fromJson(json),
            toJson: (model) => model.toJson(),
          ),
        ),

        onSuccess: (data) => onSuccess?.call(data.data)
    );
  }
}