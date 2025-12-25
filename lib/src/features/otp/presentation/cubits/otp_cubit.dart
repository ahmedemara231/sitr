import 'dart:async';
import 'dart:developer';
import '../../../../config/res/config_imports.dart' show injector;
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../auth/presentation/data/auth_data.dart';
import '../../../auth/presentation/enums/complete_register_status.dart';
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
      onSuccess: (data)async {
          AuthData.unauthorizedUserGender = data.data.gender!.userGender!;
          AuthData.unauthorizedUserType = data.data.type!.userType!;

          if(data.data.completeRegistration?.toCompleteRegisterStatus().isCompleted ?? false){
            await UserCubit.instance.setUserLoggedIn(user: data.data, token: data.data.token??'');
          }else{
            injector<NetworkService>().setToken(data.data.token??'');
          }

          onSuccess?.call(data.data);
      }
    );
  }
}