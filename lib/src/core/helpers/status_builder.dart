import 'package:flutter/cupertino.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../shared/base_state.dart';
import '../widgets/custom_loading.dart';
import '../widgets/exeption_view.dart';

class StatusBuilder<T> extends StatelessWidget {
  final AsyncState<T> data;
  final Widget Function(T data, BuildContext context) onSuccess;
  final Widget Function()? onFail;
  final Widget Function()? onLoading;
  final Size? errorWidgetSize;
  final Widget? emptyWidget;

  const StatusBuilder({
    super.key,
    required this.data,
    required this.onSuccess,
    this.onFail,
    this.onLoading,
    this.errorWidgetSize,
    this.emptyWidget,
  });

  bool get _isDataEmpty {
    final Object? value = data.data;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    if (value is String) return value.isEmpty;
    return false;
  }

  Widget _buildSuccess(BuildContext context) {
    if (_isDataEmpty && emptyWidget != null) return emptyWidget!;
    return onSuccess(data.data, context);
  }

  @override
  Widget build(BuildContext context) {
    return data.status.when(onSuccess: () {
      return _buildSuccess(context);
    }, onLoading: () {
      return onLoading?.call() ??
          Center(child: CustomLoading.showLoadingView());
    }, onError: () {
      // if (data.data != null) { // لو عايزين نظهر الداتا ال initial اما اول request fails
      //   return onSuccess(data.data, context);
      // }
      return onFail?.call() ?? ExceptionView(size: errorWidgetSize);
    }, onInitial: () {
      return _buildSuccess(context);
    });
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
      ),
    );
  }
}
