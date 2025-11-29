import 'dart:convert';
import 'dart:io';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/num.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
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
        MessageUtils.showSnackBar(data.msg);
        2.pop();
      },
    );
  }
}
