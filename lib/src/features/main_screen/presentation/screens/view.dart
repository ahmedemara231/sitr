import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/scaffolds/center_card_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/home_data.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home/filter_icon.dart';
import '../widgets/home/mariage_consultant.dart';
import '../widgets/home/parent_card.dart';
import '../widgets/home/partner_card.dart';
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

  bool current = false;
  late final ScrollController screenScrollCont = ScrollController();
  late final ScrollController paginationScrollCont = ScrollController();
  late ScrollPhysics screenPhysics = const AlwaysScrollableScrollPhysics();
  late ScrollPhysics paginationPhysics = const AlwaysScrollableScrollPhysics();

  void screenListener(){
    if(screenScrollCont.position.pixels == screenScrollCont.position.maxScrollExtent){
      setState(() {
        screenPhysics = const NeverScrollableScrollPhysics();
        paginationPhysics = const AlwaysScrollableScrollPhysics();
      });
    }
  }

  void paginationListener(){
    if(paginationScrollCont.position.pixels == paginationScrollCont.position.minScrollExtent){
      paginationPhysics = const NeverScrollableScrollPhysics();
      screenPhysics = const AlwaysScrollableScrollPhysics();
    }
  }

  @override
  void initState() {
    screenScrollCont.addListener(screenListener);
    paginationScrollCont.addListener(paginationListener);

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
          // scrollController: screenScrollCont,
          // physics: screenPhysics,
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
                    images: state.data.banners?.map((e) => e.image??'').toList() ?? []
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
                            builder: (context, val, child) => SizedBox(
                              height: context.height - 200,
                              child: AppPagify(
                                  key: UniqueKey(),
                                  asyncCall: (context, page) => HomeData.getOpportunities(val.toUserGender(), page),
                                  itemBuilder: (context, data, i, element) => InkWell(
                                    onTap: () => UserModel.isAuthenticated? Go.to(IndividualDetailsScreen.opportunity(
                                      id: element.id ?? 0,
                                    )) : Helpers.showUnauthenticatedSheet(),

                                    child: !val.toUserType().isParent?
                                    PartnerCard.individual(opportunity: element).paddingBottom(16.h) : ParentCard(
                                        parentImage: element?.avatar??'',
                                        name: element?.name??'',
                                        kinship: element?.relation?.name ?? '',
                                        childrenNumber: element?.numOfChildren ?? 0
                                    ).paddingBottom(16.h),
                                  ),
                                  // scrollController: paginationScrollCont,
                                  pagifyController: PagifyController()
                              ),
                            ),
                          )
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

