import 'dart:developer';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../models/shared_form_fields_model.dart';

class CompleteProfileCubit extends AsyncCubit<UserModel>{
  CompleteProfileCubit() : super(UserModel.initial());

  Future<void> completeProfile({
    required bool isParent,
    required SharedFormFieldModel body
})async{
    setLoading();
    await executeAsync(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: isParent?
                ApiConstants.addChild :
                ApiConstants.completeRegister,

                httpRequestType: HttpRequestType.post,
                body: body.toJson(),
                mapper: (data) => UserModel.fromJson(data)
            )
        ),

        successEmitter: (data) => setSuccess(data: data)
    );
  }
}