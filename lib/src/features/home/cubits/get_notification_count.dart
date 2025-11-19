import '../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/shared/base_state.dart';

class GetNotificationCountCubit extends AsyncCubit<int>{
    GetNotificationCountCubit() : super(0);

    Future<void> getNotificationCount()async{
      await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.getNotificationsCount,
          httpRequestType: HttpRequestType.get,
          mapper: (json) => json['count']
        ),
      ));
    }
}