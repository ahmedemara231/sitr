import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

class ChangeLangCubit extends AsyncCubit{
  ChangeLangCubit() : super('');

  Future<void> changeLang(String newLang)async{
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.changeLang,
          httpRequestType: HttpRequestType.post,
          queryParameters: {
            'lang': newLang,
            'device_id' : NotificationService.deviceToken,
            'device_type' : Helpers.deviceType,
            '_method' : 'patch'
          },
        ),
      ),
    );
  }
}