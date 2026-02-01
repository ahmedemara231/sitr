import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
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
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/center_card_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/home_model.dart';
import '../cubits/get_opportunities_cubit.dart';
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

  // late final PagifyController<OpportunityModel> _cont = PagifyController<OpportunityModel>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetOpportunitiesCubit()),
        BlocProvider(create: (context) => MainViewCubit()..getHomeData()),
      ],
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
                              child: BlocBuilder<GetOpportunitiesCubit, AsyncState<(List<OpportunityModel>, PaginationData)>>(
                                builder: (context, state) => StatusBuilder(
                                  data: state,
                                  onSuccess: (data, context) => data.$1.isEmpty? const NotContainData() :
                                  Column(
                                    children: List.generate(
                                        data.$1.length,
                                        (index) {
                                          final element = data.$1[index];
                                          return InkWell(
                                              onTap: () => UserModel.isAuthenticated? Go.to(
                                                  !(val.toUserGender().isMale || val.toUserGender().isFemale)?
                                                  ParentDetailsScreen(id: element.id??0) :
                                                  IndividualDetailsScreen.opportunity(
                                                    id: element.id ?? 0,
                                                  )
                                              ) : Helpers.showUnauthenticatedSheet(),
                                              child: !(val.toUserGender().isMale || val.toUserGender().isFemale)?
                                              ParentCard(
                                                  parentImage: (element as Parent).avatar ??'',
                                                  name: element.name??'',
                                                  kinship: element.relation?.name??'',
                                                  childrenNumber: element.numOfChildren??0
                                              ):
                                              PartnerCard.individual(opportunity: element as Opportunity).paddingBottom(16.h)
                                          );
                                        }
                                    ),
                                  ),
                                ),
                              ),
                              // child: AppPagify<OpportunityModel>(
                              //     key: UniqueKey(),
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     asyncCall: (context, page) => HomeData.getOpportunities(val.toUserGender(), page),
                              //     itemBuilder: (context, data, i, element) => InkWell(
                              //       onTap: () => UserModel.isAuthenticated? Go.to(
                              //           !(val.toUserGender().isMale || val.toUserGender().isFemale)?
                              //           ParentDetailsScreen(id: element.id??0) :
                              //           IndividualDetailsScreen.opportunity(
                              //             id: element.id ?? 0,
                              //           )
                              //       ) : Helpers.showUnauthenticatedSheet(),
                              //       child: !(val.toUserGender().isMale || val.toUserGender().isFemale)?
                              //       ParentCard(
                              //           parentImage: (element as Parent).avatar ??'',
                              //           name: element.name??'',
                              //           kinship: element.relation?.name??'',
                              //           childrenNumber: element.numOfChildren??0
                              //       ):
                              //       PartnerCard.individual(opportunity: element as Opportunity).paddingBottom(16.h)
                              //     ),
                              //     // scrollController: paginationScrollCont,
                              //     pagifyController: PagifyController()
                              // ),
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

