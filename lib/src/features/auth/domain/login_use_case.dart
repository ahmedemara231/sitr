// import 'package:multiple_result/src/result.dart';
//
// import '../../../config/res/config_imports.dart';
// import '../../../core/base_crud/code/domain/usecases/pagination_response.dart';
// import '../../../core/error/failure.dart';
// import '../../../core/extensions/error_handler_extension.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../../core/network/network_request.dart';
// import '../../../core/network/network_service.dart';
// import '../../../core/shared/models/user_model.dart';
// import '../../../core/standard/use_case.dart';
// import 'models/login_body.dart';
//
// class LoginUseCase extends UseCase<BaseModel<UserModel>, LoginBody>{
//   @override
//   Future<Result<BaseModel<UserModel>, Failure>> call(LoginBody body) async{
//     return await injector<NetworkService>().callApi(
//         NetworkRequest(
//           method: RequestMethod.post,
//           path: ApiConstants.login,
//           body: body.toJson(),
//         ),
//       mapper: (json) => UserModel.fromJson(json),
//     ).handleCallbackWithFailure()
//   }
// }