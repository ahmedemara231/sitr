import 'dart:io';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class UploadImageCubit extends AsyncCubit<String>{
  UploadImageCubit() : super('');

  Future<void> uploadImage({required File image, required String roomId, required Function(String url) onSuccess})async{
    await executeAsyncWithBaseModel(
    operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.uploadImage+roomId,
          isFromData: true,
          httpRequestType: HttpRequestType.post,
          mapper: (json) => json['file_name'],
          body: {'file' : image}
        )
       ),
      onSuccess: (data) => onSuccess(data.data)
    );
  }
}