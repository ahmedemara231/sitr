import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class EditChildDataCubit extends AsyncCubit<UserModel>{
  EditChildDataCubit() : super(UserModel.initial());

  Future<void> editChildData(IndividualUserModel child, {void Function()? onSuccess})async{
    await executeAsync(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: ApiConstants.addChild,
                httpRequestType: HttpRequestType.post,
                body: child.toRequestBodyJson(true),
                queryParameters: {'_method' : 'put'},
                mapper: (data) => UserModel.fromJson(data)
            )
        ),

        successEmitter: (data) => onSuccess?.call()
    );
  }

}