// import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
// import '../../../data/more_data.dart';
// import '../../models/block_user_model.dart';
//
// class FetchBlockUserCubit extends AsyncCubit<List<BlockUserModel>>{
//   FetchBlockUserCubit():super([]);
//   Future<void> fetchBlockUser() async {
//     await executeAsync(
//         operation: () async => await BlockUserData.getBlockedUsers()
//     );
//   }
//
//
//   void removeItemById(int id){
//     final updatedList=state.data.where((element) => element.id!=id).toList();
//     setSuccess(data: updatedList);
//   }
// }