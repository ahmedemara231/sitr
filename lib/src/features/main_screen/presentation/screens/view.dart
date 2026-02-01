import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading.dart';
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

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GetOpportunitiesCubit()..getOpportunities(type: LocaleKeys.female.toUserGender(), page: 1),
        child: const MainViewBody()
    );
  }
}

class MainViewBody extends StatefulWidget {
  const MainViewBody({super.key});

  @override
  State<MainViewBody> createState() => _MainViewBodyState();
}

class _MainViewBodyState extends State<MainViewBody> {
  late ValueNotifier<String> firstSelection;
  late ValueNotifier<String> secondSelection;

  void _initSelections(){
    firstSelection = ValueNotifier(_partnersOrConsultants.first);
    secondSelection = ValueNotifier(_opportunitiesTitles.first);
  }

  int _page = 1;
  late final ScrollController _scrollController = ScrollController()..addListener(_onScroll);

  void _onScroll(){
    if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
      final cubit = context.read<GetOpportunitiesCubit>();
      if(cubit.canLoadMore){
        _page++;
        cubit.getOpportunities(
            type: secondSelection.value.toUserGender(),
            page: _page
        );
      }
    }
  }

  @override
  void initState() {
    _initSelections();
    firstSelection.addListener(_firstSelectionListener);
    secondSelection.addListener(_secondSelectionListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _firstSelectionListener(){
    if(firstSelection.value == _partnersOrConsultants.first){
      secondSelection.value = _opportunitiesTitles.first;
    }
  }

  void _secondSelectionListener(){
    _page = 1;
    context.read<GetOpportunitiesCubit>().getOpportunities(
        type: secondSelection.value.toUserGender(),
        page: 1
    );
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainViewCubit()..getHomeData()),
      ],
      child: BlocBuilder<MainViewCubit, AsyncState<HomeModel>>(
        builder: (context, state) => SliverCenterCardScaffold(
            scrollController: _scrollController,
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
            headerContent: StatusBuilder(
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
                      ChooseFromOptionsWidget(
                        fontWeight: FontWeight.w500,
                        onSelectOption: (selectedOption) => secondSelection.value = selectedOption,
                        childPadding: EdgeInsets.symmetric(vertical: 12.h),
                        titles: _opportunitiesTitles,
                        fontSize: 14.sp,
                      ) : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            bodyBuilder: (context) => ValueListenableBuilder(
              valueListenable: firstSelection,
              builder: (context, value, child) => value == _partnersOrConsultants.first?
                BlocBuilder<GetOpportunitiesCubit, AsyncState<(List<OpportunityModel>, PaginationData)>>(
                  builder: (context, oppState) => StatusBuilder(
                    data: oppState,
                    onSuccess: (data, context) => data.$1.isEmpty? const NotContainData() :
                    ValueListenableBuilder(
                      valueListenable: secondSelection,
                      builder: (context, val, child) => Column(
                        children: [
                          ...List.generate(
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
                          if(oppState.isLoadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child:  CustomLoading.showLoadingView(),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                ),
            ),
        ),
      ),
    );
  }
}
