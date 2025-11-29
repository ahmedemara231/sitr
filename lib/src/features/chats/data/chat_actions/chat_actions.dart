part of 'imports.dart';

abstract class ChatActions{
  static Future<void> executeReq({
    required BuildContext context,
    required String path,
    required RequestModel requestModel,
    required void Function(ChatModel model) onSuccess
  }) => context.read<ChatCubit>().executeRequest(
      path: path,
      requestModel: requestModel,
      onSuccess: onSuccess
  );

  Future<void> call();
}