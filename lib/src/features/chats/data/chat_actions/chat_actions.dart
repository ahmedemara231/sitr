part of 'imports.dart';

abstract class ChatActions{
  static Future<void> executeReq({
    required BuildContext context,
    required String path,
    required RequestModel requestModel,
    required void Function(ChatModel model) onSuccess,
    Map<String, dynamic>? additionalBody,
  }) => context.read<ChatCubit>().executeRequest(
      path: path,
      additionalBody: additionalBody,
      requestModel: requestModel,
      onSuccess: onSuccess
  );

  Future<void> call();
}