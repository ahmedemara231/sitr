import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

class ChangeLangCubit extends AsyncCubit<String>{
  ChangeLangCubit() : super('');

  Future<void> changeLang(String newLang)async{
    await executeAsync(
      operation: () async => await baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.changeLang,
          httpRequestType: HttpRequestType.get,
          queryParameters: {
            'lang': newLang,
            'device_id' : NotificationService.deviceToken,
            'device_type' : 'ios'
          }
        ),
      ),
    );
  }
}