import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

class DeleteAccountCubit extends AsyncCubit{
  DeleteAccountCubit() : super(null);

  Future<void> deleteAccount({required void Function(String msg) onSuccess})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.deleteAccount,
                httpRequestType: HttpRequestType.post,
                body: {'device_id' : NotificationService.deviceToken}
            )
        ),
        onSuccess: (data) => onSuccess.call(data.msg)
    );
  }
}