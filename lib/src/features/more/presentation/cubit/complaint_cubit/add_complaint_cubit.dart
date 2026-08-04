import 'dart:io';

import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/num.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/custom_messages.dart';

class AddComplaintCubit extends AsyncCubit<bool> {
  AddComplaintCubit() : super(false) ;

  Future<void> addComplaint({
    required String title,
    required List<File> file,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call(CrudBaseParmas(
        api: ApiConstants.addComplaint,
        httpRequestType: HttpRequestType.post,
        body: {"complaint": title, "images[]": file},
        isFromData: true,
        mapper: (data) => true,
      )),
      onSuccess: (data) {
        MessageUtils.show(data.msg, state: MsgState.success);
        2.pop();
      },
    );
  }
}
