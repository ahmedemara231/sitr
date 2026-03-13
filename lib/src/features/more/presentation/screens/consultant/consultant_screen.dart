// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../../config/language/locale_keys.g.dart';
// import '../../../../../config/res/config_imports.dart';
// import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
// import '../../../../../core/extensions/padding_extension.dart';
// import '../../../../../core/extensions/sized_box_helper.dart';
// import '../../../../../core/widgets/custom_app_bar.dart';
// import '../../../../../core/widgets/custom_loading.dart';
// import '../../../../../core/widgets/not_contain_data.dart';
// import '../../cubit/consultant_cubit/consultant_cubit.dart';
// import '../../models/consultant_model.dart';
// import 'widgets/consultant_item.dart';
//
// class ConsultantScreen extends StatelessWidget {
//   const ConsultantScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ConsultantCubit()
//         ..fetchConsultant(),
//       child: Scaffold(
//         backgroundColor: AppColors.whiteScaffoldBackground,
//
//         appBar: customAppBar(appBarTitle: LocaleKeys.consultants),
//         body: BlocBuilder<ConsultantCubit, AsyncState<List<ConsultantModel>>>(
//           builder: (context, state) {
//             return  state.data.isEmpty?const NotContainData():ListView
//                 .separated(
//               controller: context.read<ConsultantCubit>().scrollController,
//               itemBuilder: (context, index) {
//                 if(index==  state.data.length){
//                   if(state.isLoadingMore){
//                     return    CustomLoading.showLoadingView();
//                   }else{
//                     return const SizedBox.shrink();
//                   }
//                 }
//
//                 return
//                   ConsultantItem(consultantModel: state.data[index]);
//               },
//               separatorBuilder: (context, index) => 10.szH,
//               itemCount:  state.data.length+1,);
//           },
//         )
//             .paddingAll(16.r),
//       ),
//     );
//   }
// }
//
