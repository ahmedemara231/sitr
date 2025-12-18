import 'dart:developer';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../models/shared_form_fields_model.dart';
import '../data/auth_data.dart';

class AddChildCubit extends AsyncCubit<UserModel>{
  AddChildCubit() : super(UserModel.initial());

  Future<void> addChild({
    required IndividualUserModel body,
    required void Function(BaseModel<UserModel> data) onSuccess
  })async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call<UserModel>(
            CrudBaseParmas(
                api: ApiConstants.addChild,
                isFromData: true,
                httpRequestType: HttpRequestType.post,
                body: body.toRequestBodyJson(true),
                mapper: (data) => UserModel.fromJson(data)
            )
        ),

        onSuccess: (data)async {
          // final parent = data.data as ParentModel;
          // AuthData.childrenNumber.value.femaleNumbers = parent.femaleChildrenNum??0;
          // AuthData.childrenNumber.value.maleNumbers = parent.maleChildrenNum??0;
          final parent = data.data as ParentModel;
          final oldParent = UserCubit.instance.user as ParentModel;
          final newParent = oldParent.copyWith(
              femaleChildrenNum: parent.femaleChildrenNum,
              maleChildrenNum: parent.maleChildrenNum
          );
          await UserCubit.instance.updateUser(newParent);
          onSuccess.call(data);
        }
    );
  }
}