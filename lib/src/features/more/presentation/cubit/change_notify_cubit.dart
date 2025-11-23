import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/shared/base_state.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';

class ChangeNotifyCubit extends AsyncCubit<bool>{
  ChangeNotifyCubit() : super(UserCubit.instance.user.isNotify ?? false);

  void changeNotifyLocally(){
    final old = state.data;
    emit(state.copyWith(status: BaseStatus.success, data: !old));
  }

  Future<void> changeNotify()async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
              api: ApiConstants.switchNotify,
              httpRequestType: HttpRequestType.patch,
              queryParameters: {
                'device_id' : NotificationService.deviceToken,
                'device_type' : 'ios'
              },
              mapper: (json) => json['is_notify']
            ),
        ),
    );
  }
}