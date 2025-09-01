import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/login_body.dart';

class LoginCubit extends AsyncCubit{
  LoginCubit() : super('');

  Future<void> login(LoginBody body)async{
    setLoading();
    await executeAsync(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.login,
                httpRequestType: HttpRequestType.post,
                body: body.toJson(),
                mapper: (data) => ''
            )
        ),

      successEmitter: (data) => setSuccess(data: data)
    );
  }

}