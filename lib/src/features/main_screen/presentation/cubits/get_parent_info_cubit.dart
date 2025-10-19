// import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
// import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../../../../core/shared/convert_user_model_to_data_list_cubit.dart';
// import '../../../../core/shared/models/user_models/parent/parent_model.dart';
// import '../../../../core/shared/models/user_models/user_model.dart';
//
// class GetParentInfoCubit extends GetUserModelCubit{
//
//   // getPartnerInfo
//   Future<void> getParentDetails(int id)async{
//     await executeAsync(
//         operation: () async => await baseCrudUseCase.call<UserModel>(
//             CrudBaseParmas(
//                 api: isParent?
//                 ApiConstants.addChild :
//                 ApiConstants.completeRegister,
//
//                 httpRequestType: HttpRequestType.post,
//                 body: body.toRequestBodyJson(false),
//                 mapper: (data) => UserModel.fromJson(data)
//             )
//         ),
//
//         successEmitter: (data) => onSuccess.call()
//     );
//   }
//
//   @override
//   Future<void> getUserModelData({required void Function(UserModel data) onSuccess}) async{
//     await executeAsync(
//     operation: () async => await baseCrudUseCase.call<UserModel>(
//         CrudBaseParmas(
//             api: ApiConstants.getPartnerInfo,
//             httpRequestType: HttpRequestType.post,
//             body: body.toRequestBodyJson(false),
//             mapper: (data) => UserModel.fromJson(data)
//         )
//     ),
//
//     successEmitter: (data) => onSuccess.call()
//     );
//   }
// }