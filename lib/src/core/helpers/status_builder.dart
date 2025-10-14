import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../config/language/locale_keys.g.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../shared/base_state.dart';
import '../widgets/custom_loading.dart';

class StatusBuilder<T> extends StatelessWidget {
  final AsyncState<T> data;
  final String? errorMessage;
  final Widget Function(T data, BuildContext context) onSuccess;
  final Widget Function()? onFail;
  final Widget Function()? onLoading;
  const StatusBuilder(
      {super.key,
        required this.data,
        required this.onSuccess,
        this.onFail,
        this.errorMessage,
        this.onLoading});

  @override
  Widget build(BuildContext context) {
    return data.status.when(onSuccess: () {
      return onSuccess(data.data, context);
    }, onLoading: () {
      return onLoading?.call() ??
          Center(child: CustomLoading.showLoadingView());
    }, onError: () {
      return onFail?.call() ??
          CenterErrorWidget(
              message: errorMessage ?? LocaleKeys.exceptionError.tr());
    },
      onInitial: () {
        return onSuccess(data.data, context);
      }
    );
  }
}

class CenterErrorWidget extends StatelessWidget {
  const CenterErrorWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        // style: context.textStyle.s14.regular.setHintColor,
      ),
    );
  }
}