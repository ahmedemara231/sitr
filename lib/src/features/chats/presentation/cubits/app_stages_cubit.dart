// import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
// import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
// import '../../../../core/network/api_endpoints.dart';
//
// class AppStagesCubit extends AsyncCubit<List<String>>{
//   AppStagesCubit() : super([]);
//
//   Future<void> getAppStages()async{
//     await executeAsyncWithBaseModel(
//       operation: () => baseCrudUseCase.call(
//           CrudBaseParmas(
//             api: ApiConstants.appStages,
//             httpRequestType: HttpRequestType.get,
//             mapper: (data) => (data as String)
//                 .split('\n\n')
//                 .map((e) => e.trim())
//                 .where((e) => e.isNotEmpty)
//                 .toList()
//           ),
//       ),
//     );
//   }
// }