import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

class LogoutCubit extends AsyncCubit{
  LogoutCubit() : super(null);

  Future<void> logout({required void Function() onSuccess})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
              api: ApiConstants.logout,
              httpRequestType: HttpRequestType.delete,
              queryParameters: {'device_id' : NotificationService.deviceToken}
            )
        ),
      onSuccess: (data) => onSuccess.call()
    );
  }
}