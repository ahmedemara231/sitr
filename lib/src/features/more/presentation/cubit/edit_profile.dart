import 'dart:developer';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../auth/models/shared_form_fields_model.dart';

class EditProfileCubit extends AsyncCubit<UserModel>{
  EditProfileCubit() : super(UserModel.initial());

  Future<void> editProfile({
    required IndividualUserModel body,
    required void Function(BaseModel<UserModel>) onSuccess
  })async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: ApiConstants.editProfile,
                httpRequestType: HttpRequestType.post,
                body: body.toRequestBodyJson(false),
                queryParameters: {
                  '_method' : 'put'
                },
                mapper: (data) => UserModel.fromJson(data)
            )
        ),

        onSuccess: (data) => onSuccess.call(data)
    );
  }
}