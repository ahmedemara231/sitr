import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/enum.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/center_card_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home/filter_icon.dart';
import '../widgets/home/mariage_consultant.dart';
import '../widgets/home/parent_card.dart';
import '../widgets/home/partner_card.dart';
import 'parent_details.dart';
import 'partner_details.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late ValueNotifier<String> firstSelection;
  late ValueNotifier<String> secondSelection;


  void _initSelections(){
    firstSelection = ValueNotifier(_partnersOrConsultants.first);
    secondSelection = ValueNotifier(_opportunitiesTitles.first);
  }
  @override
  void initState() {
    _initSelections();
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

    return [
      LocaleKeys.male,
      LocaleKeys.female,
      LocaleKeys.parents
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                            if(val == UserGender.male.translate){
                              if(data.opportunities!.male.isNull || data.opportunities!.male!.isEmpty){
                                return const NotContainData();
                              }else{
                                return Column(
                                  spacing: 10.h,
                                  children: List.generate(
                                      state.data.opportunities?.male?.length ?? 0,
                                          (index) {
                                        final opportunity = state.data.opportunities?.male?[index];
                                        return InkWell(
                                          onTap: () => UserModel.isAuthenticated? Go.to(IndividualDetailsScreen.opportunity(
                                            id: opportunity.id ?? 0,
                                          )) : Helpers.showUnauthenticatedSheet(),

                                          child: PartnerCard.individual(opportunity: opportunity!),
                                        );
                                      }
                                  ),
                                );
                              }
                            }
                            else if(val == UserGender.female.translate){
                              if(data.opportunities!.female.isNull || data.opportunities!.female!.isEmpty){
                                return const NotContainData();

                              }else{
                                return Column(
                                  spacing: 10.h,
                                  children: List.generate(
                                      state.data.opportunities?.female?.length ?? 0,
                                          (index) {
                                        final opportunity = state.data.opportunities?.female?[index];
                                        return InkWell(
                                          onTap: () => UserModel.isAuthenticated? Go.to(IndividualDetailsScreen.opportunity(
                                            id: opportunity.id ?? 0,
                                          )) : Helpers.showUnauthenticatedSheet(),
                                          child: PartnerCard.individual(opportunity: opportunity!),
                                        );
                                      }
                                  ),
                                );
                              }
                            }
                            else{
                              if(data.opportunities!.parent.isNull || data.opportunities!.parent!.isEmpty){
                                return const NotContainData();

                              }else{
                                return Column(
                                  spacing: 10.h,
                                  children: List.generate(
                                      state.data.opportunities?.parent?.length ?? 0,
                                          (index) {
                                        final opportunity = state.data.opportunities?.parent?[index];
                                        return InkWell(
                                          onTap: () => UserModel.isAuthenticated?
                                          Go.to(ParentDetailsScreen(id: opportunity?.id ?? 0)):
                                          Helpers.showUnauthenticatedSheet(),
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
        ).withPullRefresher(
          onRefresh: () async{
            _initSelections();
            await context.read<MainViewCubit>().getHomeData();
          },
        ),
      ),
    );
  }
}
