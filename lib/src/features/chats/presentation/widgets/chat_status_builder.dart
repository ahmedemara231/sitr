import 'package:flutter/material.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/status_builder.dart';

class ChatStatusBuilder<T> extends StatelessWidget {
  final AsyncState<T> data;
  final Widget Function(T data, BuildContext context) onSuccess;
  const ChatStatusBuilder({super.key,
        required this.data,
        required this.onSuccess,
      });

  @override
  Widget build(BuildContext context) {
    return StatusBuilder(
      data: data, onSuccess: onSuccess,
      onFail: () => onSuccess.call(data.data, context),
    );
  }
}
