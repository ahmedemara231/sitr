import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../models/sign_up_body.dart';

class SignUpCubit extends AsyncCubit{
  SignUpCubit() : super(null);

  Future<void> signUp(SignUpBody body) async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
            CrudBaseParmas(
                isFromData: true,
                api: ApiConstants.register,
                httpRequestType: HttpRequestType.post,
                body: body.toJson(),
                mapper: (json) => null
            )
        )
    );
  }

}