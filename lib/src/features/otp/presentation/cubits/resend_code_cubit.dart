import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../models/resend_code_body.dart';

class ResendCodeCubit extends AsyncCubit{
  ResendCodeCubit() : super(null);

  Future<void> resendOtp({required ResendCodeBody body}) async {
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
              api: ApiConstants.resendCode,
              httpRequestType: HttpRequestType.get,
              body: body.toJson(),
              mapper: (json) => null
          ),
        ),
    );
  }
}