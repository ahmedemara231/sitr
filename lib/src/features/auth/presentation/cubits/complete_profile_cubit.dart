import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_model.dart';
import '../../models/complete_profile_body.dart';
import '../../models/login_body.dart';

class CompleteProfileCubit extends AsyncCubit<UserModel>{
  CompleteProfileCubit() : super(UserModel.initial());

  Future<void> completeProfile(CompleteProfileModel body)async{
    setLoading();
    await executeAsync(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: ApiConstants.login,
                httpRequestType: HttpRequestType.post,
                body: body.toJson(),
                mapper: (data) => UserModel.fromJson(data)
            )
        ),

        successEmitter: (data) => setSuccess(data: data)
    );
  }

}