// import 'dart:developer';
// import 'package:pagify/helpers/data_and_pagination_data.dart';
// import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
// import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
// import '../../../../core/helpers/user_type_enum.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../../../../core/shared/models/user_models/user_model.dart';
// import '../../models/package.dart';
//
// class GetPackagesCubit extends AsyncCubit<(List<Package>, PaginationData)>{
//   GetPackagesCubit() : super(([], PaginationData(totalPages: 0, perPage: 0)));
//
//   String _getEndPoint(){
//     // final user = UserModel.currentUser.gender?.userType;
//     // final isParent = UserModel.isParent;
//
//     // log('UserTypeHelper.currentType ${UserModel.currentUser}');
//     // log('UserTypeHelper.currentType ${UserModel.currentUser.runtimeType}');
//     if(UserModel.isParent){
//       return ApiConstants.getPackages+ApiConstants.family;
//
//     }else{
//       return ApiConstants.getPackages+ApiConstants.individual;
//     }
//   }
//
//   Future<(List<Package>, PaginationData)> getPackages()async{
//    return (await baseCrudUseCase.call<(List<Package>, PaginationData)>(
//         CrudBaseParmas(
//             api: _getEndPoint(),
//             httpRequestType: HttpRequestType.get,
//             mapper: (json) => (
//             (json['data'] as List)
//                 .map((e) => Package.fromJson(e))
//                 .toList(),
//             PaginationData(
//                 perPage: json['pagination']['per_page'],
//                 totalPages: json['pagination']['total_pages']
//             ),
//             ),
//         ),
//     )).getOrThrow();
//   }
//
// }