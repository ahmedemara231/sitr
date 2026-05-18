import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../core/extensions/object.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/shared/base_state.dart';
import '../../../core/shared/models/user_models/user_model.dart';

class GetNotificationCountCubit extends AsyncCubit<int>{
    GetNotificationCountCubit() : super(0);

    @override
    reset(){
      emit(state.copyWith(data: 0));
    }

    void startNotificationInterceptor(){
      if(UserModel.isAuthenticated){
        FirebaseMessaging
            .onMessage
            .listen((data) => increment()
        );
      }
    }

    void increment(){
      emit(state.copyWith(
          status: BaseStatus.success,
          data: state.data + 1
      ));
    }

    Future<void> getNotificationCount()async{
      if(UserModel.isAuthenticated){
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
}

class GetChatsNotificationCountCubit extends AsyncCubit<int>{
  GetChatsNotificationCountCubit() : super(0);

  @override
  reset(){
    emit(state.copyWith(data: 0));
  }

  void startNotificationInterceptor(){
    if(UserModel.isAuthenticated){
      FirebaseMessaging
          .onMessage
          .listen((data) {
        final matchRequest = data.data['match_request_id'];
        if((matchRequest as Object?).isNotNull){
          increment();
        }}
      );
    }
  }

  void increment(){
    emit(state.copyWith(
        status: BaseStatus.success,
        data: state.data + 1
    ));
  }

  Future<void> getChatNotificationCount()async{
    if(UserModel.isAuthenticated){
      await executeAsyncWithBaseModel(
          operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.countUnreadMessages,
                httpRequestType: HttpRequestType.get,
                mapper: (json) => json['count']
            ),
          )
      );
    }
  }
}
