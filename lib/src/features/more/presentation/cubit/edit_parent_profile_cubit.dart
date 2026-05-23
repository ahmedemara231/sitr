import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../auth/models/edit_parent_profile_model.dart';

class EditParentProfileCubit extends AsyncCubit<UserModel> {
  EditParentProfileCubit() : super(UserModel.initial());

  Future<void> editParentProfile({
    required EditParentProfileModel body,
    required void Function(BaseModel<UserModel>) onSuccess,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call<UserModel>(
        CrudBaseParmas(
          api: ApiConstants.editProfile,
          isFromData: true,
          httpRequestType: HttpRequestType.post,
          body: body.toJson(),
          queryParameters: {
            '_method': 'put',
          },
          mapper: (data) => UserModel.fromJson(data),
        ),
      ),
      onSuccess: (data) => onSuccess.call(data),
    );
  }
}
