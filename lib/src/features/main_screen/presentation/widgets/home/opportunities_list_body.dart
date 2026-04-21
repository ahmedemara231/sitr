import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../../data/models/home_model.dart';
import '../../cubits/get_opportunities_cubit.dart';
import '../../screens/parent_details.dart';
import '../../screens/partner_details.dart';
import 'parent_card.dart';
import 'partner_card.dart';

class OpportunitiesListBody extends StatelessWidget {
  final ValueNotifier<String> secondSelection;

  const OpportunitiesListBody({
    super.key,
    required this.secondSelection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOpportunitiesCubit, AsyncState<(List<OpportunityModel>, PaginationData)>>(
      builder: (context, oppState) => StatusBuilder(
        data: oppState,
        onSuccess: (data, context) => data.$1.isEmpty
            ? const NotContainData()
            : ValueListenableBuilder(
                valueListenable: secondSelection,
                builder: (context, val, child) => Column(
                  children: [
                    ...List.generate(data.$1.length, (index) {
                      final element = data.$1[index];
                      final isParent = !(val.toUserGender().isMale || val.toUserGender().isFemale);
                      return InkWell(
                        onTap: () => UserModel.isAuthenticated
                            ? Go.to(
                                isParent
                                    ? ParentDetailsScreen(id: element.id ?? 0)
                                    : IndividualDetailsScreen.opportunity(id: element.id ?? 0),
                              )
                            : Helpers.showUnauthenticatedSheet(),
                        child: isParent
                            ? ParentCard(
                                parentImage: (element as Parent).avatar ?? '',
                                name: element.name ?? '',
                                kinship: element.relation?.name ?? '',
                                childrenNumber: element.numOfChildren ?? 0,
                              )
                            : PartnerCard.individual(opportunity: element as Opportunity)
                                .paddingBottom(16.h),
                      );
                    }),
                    if (oppState.isLoadingMore)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: CustomLoading.showLoadingView(),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
