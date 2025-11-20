import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/add_frame.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/enum.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../../../core/widgets/sheets/chat_requests_sheet.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home/filter_icon.dart';
import '../widgets/home/mariage_consultant.dart';
import '../widgets/home/parent_card.dart';
import '../widgets/home/partner_card.dart';
import 'parent_details.dart';
import 'partner_details.dart';


class MainView extends StatefulWidget {
  MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final ValueNotifier<String> firstSelection;
  late final ValueNotifier<String> secondSelection;

  @override
  void initState() {
    firstSelection = ValueNotifier(_partnersOrConsultants.first);
    secondSelection = ValueNotifier(_opportunitiesTitles.first);
    firstSelection.addListener(firstSelectionListener);
    super.initState();
  }

  void firstSelectionListener(){
    if(firstSelection.value == _partnersOrConsultants.first){
      secondSelection.value = _opportunitiesTitles.first;
    }
  }

  List<String> get _partnersOrConsultants => [
    LocaleKeys.searchForLifePartner,
    LocaleKeys.mediatorsAndServices
  ];

  List<String> get _opportunitiesTitles {
    if(UserModel.isParent){
      return [
        LocaleKeys.male,
        LocaleKeys.female,
        LocaleKeys.parents
      ];

    }else if(UserModel.isMale){
      return [
        LocaleKeys.female,
        LocaleKeys.parents
      ];

    }else if(UserModel.isFemale){
      return [
        LocaleKeys.male,
        LocaleKeys.parents
      ];

    }

    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainViewCubit()..getHomeData(),
      child: BlocBuilder<MainViewCubit, AsyncState<HomeModel>>(
        builder: (context, state) => CenterCardScaffold.withCenteredCard(
          onRefresh: (context) => context.read<MainViewCubit>().getHomeData(),
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
                      AppText(UserCubit.instance.user.name??'', fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ],
                  ),

                  const Spacer(),
                  const FilterButton(),
                ],
              ),
          ),
          bodyColor: Colors.white,
          upperWidgetPadding: const EdgeInsets.all(20),
          centerCardBody: StatusBuilder(
                data: state,
                onSuccess: (data, context) => ImageSlider(
                    height: context.height / 5,
                    images: state.data.banners!.map((e) => e.image??'').toList()
                )
            ),
          body: StatusBuilder(
            data: state,
            onSuccess: (data, context) => Column(
              children: [
                ChooseFromOptionsWidget(
                  onSelectOption: (selectedOption) => firstSelection.value = selectedOption,
                  fontSize: 14.sp,
                  childPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                  titles: _partnersOrConsultants,
                ),
                ValueListenableBuilder(
                  valueListenable: firstSelection,
                  builder: (context, value, child) => value == _partnersOrConsultants.first?
                  Column(
                    children: [
                      ChooseFromOptionsWidget(
                        fontWeight: FontWeight.w500,
                        onSelectOption: (selectedOption) => secondSelection.value = selectedOption,
                        childPadding: EdgeInsets.symmetric(vertical: 12.h),
                        titles: _opportunitiesTitles,
                        fontSize: 14.sp,
                      ),

                      ValueListenableBuilder(
                          valueListenable: secondSelection,
                          builder: (context, val, child) {
                            if(val == UserType.male.translate){
                              return Column(
                                spacing: 10.h,
                                children: List.generate(
                                    state.data.opportunities?.male?.length ?? 0,
                                        (index) {
                                      final opportunity = state.data.opportunities?.male?[index];
                                      return InkWell(
                                        onTap: () => Go.to(IndividualDetailsScreen.opportunity(
                                          id: opportunity.id ?? 0,
                                        )),
                                        child: PartnerCard.individual(opportunity: opportunity!),
                                      );
                                    }
                                ),
                              );

                            }
                            else if(val == UserType.female.translate){
                              return Column(
                                spacing: 10.h,
                                children: List.generate(
                                    state.data.opportunities?.female?.length ?? 0,
                                        (index) {
                                      final opportunity = state.data.opportunities?.female?[index];
                                      return InkWell(
                                        onTap: () => Go.to(IndividualDetailsScreen.opportunity(
                                              id: opportunity.id ?? 0,
                                            )),
                                        child: PartnerCard.individual(opportunity: opportunity!),
                                      );
                                    }
                                ),
                              );

                            }
                            else{
                              return Column(
                                spacing: 10.h,
                                children: List.generate(
                                    state.data.opportunities?.parent?.length ?? 0,
                                        (index) {
                                      final opportunity = state.data.opportunities?.parent?[index];
                                      return InkWell(
                                        onTap: () => Go.to( ParentDetailsScreen(id: opportunity?.id ?? 0)),
                                        child: ParentCard(
                                            parentImage: opportunity?.avatar??'',
                                            name: opportunity?.name??'',
                                            kinship: opportunity?.relation?.name ?? '',
                                            childrenNumber: opportunity?.numOfChildren ?? 0
                                        ),
                                      );
                                    }
                                ),
                              );
                            }
                          }
                      ),
                    ],
                  ) :
                  Column(
                    spacing: 10.h,
                    children: List.generate(
                        state.data.marriageConsultants?.length ?? 0,
                            (i) {
                          final marriageConsultant = state.data.marriageConsultants?[i];
                          return MarriageConsultantCard(
                              name: marriageConsultant?.name ?? '',
                              phone: marriageConsultant?.phone ?? '',
                              parentImage: marriageConsultant?.image ?? '',
                              description: marriageConsultant?.description ?? ''
                          );
                        }
                    ),
                  )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
