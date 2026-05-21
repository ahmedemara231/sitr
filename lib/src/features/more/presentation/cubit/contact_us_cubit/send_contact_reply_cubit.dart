import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/custom_messages.dart';

class SendContactReplyCubit extends AsyncCubit<bool> {
  SendContactReplyCubit() : super(false);

  Future<void> sendReply({
    required int id,
    required String message,
    void Function()? onSuccess,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call<bool>(CrudBaseParmas(
        api: '${ApiConstants.contactUsSendReply}$id/send-reply',
        httpRequestType: HttpRequestType.post,
        body: {'reply': message},
        mapper: (data) => true,
      )),
      onSuccess: (data) {
        MessageUtils.showSnackBar(data.msg);
        onSuccess?.call();
      },
    );
  }
}
