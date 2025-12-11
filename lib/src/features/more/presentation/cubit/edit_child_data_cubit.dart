import 'dart:developer';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class EditChildDataCubit extends AsyncCubit<UserModel>{
  EditChildDataCubit() : super(UserModel.initial());

  Future<void> editChildData(IndividualUserModel child, {void Function(BaseModel<UserModel>)? onSuccess})async{
    log('the data is ${child.toRequestBodyJson(true)}');
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: ApiConstants.updateChildProfile+child.id.toString(),
                httpRequestType: HttpRequestType.post,
                queryParameters: {
                  '_method' : 'put'
                },
                isFromData: true,
                body: child.toRequestBodyJson(true),
                mapper: (data) => UserModel.fromJson(data)
            )
        ),
        onSuccess: (data) => onSuccess?.call(data)
    );
  }

}