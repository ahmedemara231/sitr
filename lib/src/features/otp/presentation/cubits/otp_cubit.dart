import 'dart:async';
import 'dart:developer';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../auth/presentation/data/auth_data.dart';
import '../../models/otp_body.dart';

enum OtpType{afterLogin, afterRegister}
class OtpCubit extends AsyncCubit<UserModel>{
  OtpCubit() : super(UserModel.initial());

  Future<void> sendOtp({
    required OtpType type,
    required OtpBody body,
    FutureOr<void> Function(UserModel data)? onSuccess,
}) async {
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
              api: type == OtpType.afterLogin?
              ApiConstants.checkCodeAfterLogin :
              ApiConstants.activate,
              httpRequestType: type == OtpType.afterLogin?
              HttpRequestType.post : HttpRequestType.patch,
              body: body.toJson(),
              mapper: (json) => UserModel.fromJson(json)
          ),
        ),
      onSuccess: (data) {
          log('data isss ${data.data.toJson()}');
          AuthData.unauthorizedUserGender = data.data.gender!.userGender!;
          AuthData.unauthorizedUserType = data.data.type!.userType!;
          onSuccess?.call(data.data);
      }
    );
  }
}