import 'dart:async';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../widgets/sign_up/sheets/add_child_sheet.dart';

class AddChildCubit extends AsyncCubit<UserModel>{
  AddChildCubit() : super(UserModel.initial());

  Future<void> addChild({
    required IndividualUserModel body,
    FutureOr<void> Function()? cancelOnTap,
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
          final parent = data.data as ParentModel;
          if(UserModel.isAuthenticated){
            final oldParent = UserCubit.instance.user as ParentModel;
            final newParent = oldParent.copyWith(
                femaleChildrenNum: parent.femaleChildrenNum,
                maleChildrenNum: parent.maleChildrenNum
            );

            UserCubit.instance.updateUser(newParent);
          }

          showDefaultBottomSheet(child: AddChildSheet(
            maleNum: parent.maleChildrenNum,
            femaleNum: parent.femaleChildrenNum,
            cancelOnTap: cancelOnTap,
          ));
        }
    );
  }
}