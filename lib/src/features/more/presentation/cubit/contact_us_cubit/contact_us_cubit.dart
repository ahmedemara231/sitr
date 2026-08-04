import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/custom_messages.dart';
import '../../screens/contact_us/contact_us_chat_screen.dart';

class ContactUsCubit extends AsyncCubit<bool> {
  ContactUsCubit() : super(false);

  Future<void> contactUs({
    required String name,
    required String countryCode,
    required String iso,
    required String phone,
    required String message,
  }) async {
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(CrudBaseParmas(
            api: ApiConstants.contactStore,
            httpRequestType: HttpRequestType.post,
            body: {
              'name': name,
              'country_code': countryCode,
              'iso':iso,
              'phone': phone,
              'message': message,
            },
            mapper: (data) => true)),
        onSuccess: (data) {
          MessageUtils.show(data.msg, state: MsgState.success);
          Go.off(const ContactUsChatScreen());
        });
  }
}
