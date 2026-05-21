import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../models/contact_message.dart';

class ContactUsMessagesCubit extends AsyncCubit<List<ContactMessage>> {
  ContactUsMessagesCubit() : super(const []);

  Future<void> fetchMessages() async {
    await executeAsyncWithBaseModel(
      operation: () async =>
          await baseCrudUseCase.call<List<ContactMessage>>(CrudBaseParmas(
        api: ApiConstants.contactUsIndex,
        httpRequestType: HttpRequestType.get,
        mapper: (data) {
          final List<ContactMessage> bubbles = [];
          for (final raw in data as List) {
            final Map<String, dynamic> thread = raw as Map<String, dynamic>;
            final int parentId = thread['id'] ?? 0;
            final String parentName = thread['name'] ?? '';
            bubbles.add(ContactMessage.fromParentJson(thread));
            for (final r in (thread['replies'] as List? ?? const [])) {
              bubbles.add(ContactMessage.fromReplyJson(
                r as Map<String, dynamic>,
                parentId: parentId,
                parentName: parentName,
              ));
            }
          }
          return bubbles;
        },
      )),
      withInternetInterceptor: true,
    );
  }
}
