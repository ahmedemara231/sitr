import 'dart:io';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class UploadImageCubit extends AsyncCubit{
  UploadImageCubit() : super(null);

  Future<void> uploadImage(File image)async{
    await executeAsync(
    operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.uploadImage,
          httpRequestType: HttpRequestType.post,
          body: {
            'file' : image,
          }
        )
    ),
    );
  }

}