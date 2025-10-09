import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home/filter_icon.dart';
import '../widgets/home/mariage_consultant.dart';
import '../widgets/home/parent_card.dart';
import '../widgets/home/partner_card.dart';
import '../widgets/home/under_slider_widget.dart';
import 'partner_details.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final ValueNotifier<Options> firstSelection = ValueNotifier(Options.first);
  final ValueNotifier<Options> secondSelection = ValueNotifier(Options.first);
  void firstSelectionListener(){
    if(firstSelection.value == Options.first){
      secondSelection.value = Options.first;
    }
  }
  @override
  Widget build(BuildContext context) {
    firstSelection.addListener(firstSelectionListener);
    return BlocProvider(
      create: (context) => MainViewCubit()..getHomeData(),
      child: BlocBuilder<MainViewCubit, AsyncState<HomeModel>>(
        builder: (context, state) => CenterCardScaffold.withCenteredCard(
          bodyTopPadding: 120,
          cardTopPadding: 100,
          upperWidget: SizedBox(
            height: 100.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 5.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(LocaleKeys.welcome, fontSize: 12.sp),
                      AppText(UserCubit.instance.user.name??'Test', fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ],
                  ),

                  const Spacer(),
                  const FilterButton(),
                ],
              ),
          ),
          upperWidgetPadding: const EdgeInsets.all(20),
          centerCardBody: StatusBuilder(
                data: state,
                onSuccess: (data, context) => ImageSlider(
                    height: context.height / 5,
                    images: state.data.banners!.map((e) => e.image??'').toList()
                )
            ),
          body: Column(
            children: [
              UnderSliderWidget(
                onSelectOption: (selectedOption) => firstSelection.value = selectedOption,
                titles: [LocaleKeys.searchForLifePartner, LocaleKeys.mediatorsAndServices],
              ),

              ValueListenableBuilder(
                valueListenable: firstSelection,
                builder: (context, value, child) => value == Options.first? UnderSliderWidget(
                  fontWeight: FontWeight.w500,
                  onSelectOption: (selectedOption) => secondSelection.value = selectedOption,
                  titles: [
                    UserModel.isMale?
                    LocaleKeys.female :
                    LocaleKeys.male,

                    LocaleKeys.parents
                  ],
                  fontSize: 12.sp,
                  secondSlider: true,
                ) : const SizedBox.shrink(),
              ),

              ValueListenableBuilder(
                valueListenable: firstSelection,
                builder: (context, firstValue, child) => ValueListenableBuilder(
                  valueListenable: secondSelection,
                  builder: (context, secondValue, child) => Column(
                    spacing: 10.h,
                    children: firstValue == Options.first?
                    List.generate(
                        state.data.opportunities?.female?.length ?? 0,
                            (i) {
                              final Opportunity? opportunity = UserModel.isMale?
                              state.data.opportunities!.female![i] :
                              state.data.opportunities?.male?[i];

                              final parent = state.data.opportunities?.parent?[i];
                              if(secondValue == Options.first){
                                return InkWell(
                                  onTap: () => Go.to(PartnerDetails(id: opportunity?.id ?? 0)),
                                  child: PartnerCard(
                                    name: opportunity?.name ?? '',
                                    imageUrl: opportunity?.avatar ?? '',
                                    weight: opportunity?.weight.toString()??'',
                                    age: opportunity?.age??0,
                                    height: opportunity?.height?? 0,
                                    maritalStatus: opportunity?.type?.title ?? '',
                                    location: opportunity?.city ?? '',
                                  ),
                                );

                              }else{
                                return InkWell(
                                  // onTap: () => Go.to(ParentDetails()),
                                  child: ParentCard(
                                      parentImage: parent?.avatar ??'',
                                      name: parent?.name ??'',
                                      kinship: parent?.relation?.name??'',
                                      childrenNumber: parent?.numOfChildren??0
                                  ),
                                );
                              }
                            }
                    ) :
                    List.generate(
                        state.data.marriageConsultants?.length ?? 0,
                            (i) {
                          final marriageConsultant = state.data.marriageConsultants?[i];
                          final parent = state.data.opportunities?.parent?[i];
                          return MarriageConsultantCard(
                              name: marriageConsultant?.name ?? '',
                              phone: marriageConsultant?.phone ?? '',
                              parentImage: marriageConsultant?.image ?? '',
                              description: marriageConsultant?.description ?? ''
                          );
                        }
                    ),
                  ),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
