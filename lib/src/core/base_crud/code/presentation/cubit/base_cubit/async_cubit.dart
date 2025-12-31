import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../error/failure.dart';
import '../../../../../extensions/object.dart';
import '../../../../../shared/base_state.dart';
import '../../../../../widgets/custom_messages.dart';
import '../../../domain/base_domain_imports.dart';
import '../../../domain/usecases/pagination_response.dart';

part 'async_state.dart';

abstract class AsyncCubit<T> extends Cubit<AsyncState<T>> {
  AsyncCubit(T initialData) : super(AsyncState.initial(data: initialData)) {
    baseCrudUseCase = injector();
  }
  late final BaseCrudUseCase baseCrudUseCase;
  void setLoading() {
    emit(state.loading());
  }

  void setLoadingMore() {
    emit(state.loadingMore());
  }

  void setSuccess({required T data}) {
    emit(state.success(data: data));
  }

  void setError({String? errorMessage, bool showToast = false}) {
    if (showToast && errorMessage != null) {
      MessageUtils.showSnackBar(errorMessage);
    }
    emit(state.error(errorMessage: errorMessage));
  }

  void reset() {
    emit(AsyncState.initial(data: state.data));
  }

  void updateData(T data) {
    emit(state.copyWith(data: data));
  }

  void updateErrorMessage(String? errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  bool get isLoading => state.isLoading;

  Future<void> executeAsync({
    required Future<Result<T, Failure>> Function() operation,
    Function(T)? successEmitter,
  }) async {
    setLoading();
    final result = await operation();
    result.when(
          (success) {
        setSuccess(data: success);
        if (successEmitter != null) {
          successEmitter(success);
        }
      },
          (failure) {
        MessageUtils.showSnackBar(failure.message);
        setError(errorMessage: failure.message);
      },
    );
  }

  Future<void> executeAsyncWithBaseModel({
    required Future<Result<BaseModel<T>, Failure>> Function() operation,
    FutureOr<void> Function(BaseModel<T>)? onSuccess,
  }) async {
    setLoading();
    final result = await operation();
    result.when(
          (success) {
        setSuccess(data: success.data);
        if (onSuccess != null) {
          onSuccess(success);
        }
      },
          (failure) {
            // MessageUtils.showTopMsg(failure.message);

        MessageUtils.showSnackBar(failure.message);
        setError(errorMessage: failure.message);
      },
    );
  }


  StreamSubscription? _streamSubscription;
  // Future<void> executeAsyncWithBaseModel({
  //   required Future<Result<BaseModel<T>, Failure>> Function() operation,
  //   Function(BaseModel<T>)? onSuccess,
  //   bool enableInternetInterceptor = false,
  // }) async {
  //   if(enableInternetInterceptor){
  //     _basicOperationWithInternetInterceptor(
  //         operation: operation,
  //         successEmitter: onSuccess
  //     );
  //   }else{
  //     _basicOperation(
  //         operation: operation,
  //         successEmitter: onSuccess
  //     );
  //   }
  // }


  void _basicOperationWithInternetInterceptor({
    required Future<Result<BaseModel<T>, Failure>> Function() operation,
    Function(BaseModel<T>)? successEmitter,
  }){
    // Make the initial API call
    // _basicOperation(
    //     operation: operation,
    //     successEmitter: successEmitter
    // );

    _streamSubscription = Connectivity().onConnectivityChanged.listen((status){
      log('the current state is $status');
      if(status.contains(ConnectivityResult.none)){
        MessageUtils.showSnackBar(LocaleKeys.theInternetConnectionIsDisabled);
        emit(state.error(errorMessage: LocaleKeys.theInternetConnectionIsDisabled));

      }else{
        MessageUtils.showSnackBar(LocaleKeys.theInternetConnectionIsRestored);
        _basicOperation(
            operation: operation,
            successEmitter: successEmitter
        );
      }
    });
  }

  Future<void> _basicOperation({
    required Future<Result<BaseModel<T>, Failure>> Function() operation,
    Function(BaseModel<T>)? successEmitter,
  })async{
    setLoading();
    final result = await operation();
    result.when(
          (success) {
        setSuccess(data: success.data);
        if (successEmitter != null) {
          successEmitter(success);
        }
      },
          (failure) {
        MessageUtils.showSnackBar(failure.message);
        setError(errorMessage: failure.message);
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  void emit(AsyncState<T> state) {
    if (isClosed) return;
    super.emit(state);
  }
}
