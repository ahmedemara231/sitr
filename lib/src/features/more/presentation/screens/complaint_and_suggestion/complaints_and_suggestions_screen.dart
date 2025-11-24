import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../models/complaint_model.dart';
import '../../models/consultant_model.dart';
import 'add_complaint_and_suggestion.dart';
import '../../cubit/complaint_cubit/fetch_complaint_cubit.dart';
import 'widgets/complaints_and_suggestions_item.dart';

class ComplaintsAndSuggestionsScreen extends StatelessWidget {
  const ComplaintsAndSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchComplaintCubit()..fetchComplaint(),
      child: Scaffold(
        backgroundColor: AppColors.whiteScaffoldBackground,
        appBar: customAppBar(appBarTitle: LocaleKeys.complaintsAndSuggestions),
        body: Column(
          children: [
            BlocBuilder<FetchComplaintCubit, AsyncState<List<ComplaintModel>>>(
              builder: (context, state) {
                return StatusBuilder(
                  data: state,
                  onSuccess: (data,context) {
                    return Expanded(
                      child: data.isEmpty?const NotContainData():ListView.separated(
                        controller: context.read<FetchComplaintCubit>().scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context,
                              index) {
                            if(index==  state.data.length){
                              if(state.isLoadingMore){
                                return CustomLoading.showLoadingView();
                              }else{
                                return const SizedBox.shrink();
                              }
                            }
                            return  ComplaintsAndSuggestionsItem(complaintModel: data[index]);
                          },
                          separatorBuilder: (context, index) => 10.szH,
                          itemCount: data.length+1),
                    );
                  }
                );
              },
            )
          ],
        ).paddingAll(16),
        bottomNavigationBar: AppLoadingButton(
            asyncCall: (context) async {
              Go.to(const AddComplaintAndSuggestion());
            },
            title: LocaleKeys.attachNewComplaint)
            .paddingAll(16.r),
      ),
    );
  }
}

