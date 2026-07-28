import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/promotion_badge.dart';
import '../../../../core/widgets/scaffolds/center_card_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/home_model.dart';
import '../cubits/get_opportunities_cubit.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home/consultants_list_body.dart';
import '../widgets/home/home_welcome_header.dart';
import '../widgets/home/opportunities_list_body.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final ValueNotifier<String> firstSelection;
  late final ValueNotifier<String> secondSelection;

  List<String> get partnersOrConsultants => [
        LocaleKeys.searchForLifePartner,
        LocaleKeys.mediatorsAndServices,
      ];

  List<String> get opportunitiesTitles {
    if (UserModel.isParent) {
      return [LocaleKeys.male, LocaleKeys.female, LocaleKeys.parents];
    } else if (UserModel.isMale) {
      return [LocaleKeys.female, LocaleKeys.parents];
    } else if (UserModel.isFemale) {
      return [LocaleKeys.male, LocaleKeys.parents];
    }
    return [LocaleKeys.male, LocaleKeys.female, LocaleKeys.parents];
  }

  @override
  void initState() {
    super.initState();
    firstSelection = ValueNotifier(partnersOrConsultants.first);
    secondSelection = ValueNotifier(opportunitiesTitles.first);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetOpportunitiesCubit()
        ..getOpportunities(
          type: secondSelection.value.toUserGender(),
          page: 1,
        ),
      child: MainViewBody(
        firstSelection: firstSelection,
        secondSelection: secondSelection,
        partnersOrConsultants: partnersOrConsultants,
        opportunitiesTitles: opportunitiesTitles,
      ),
    );
  }
}

class MainViewBody extends StatefulWidget {
  final ValueNotifier<String> firstSelection;
  final ValueNotifier<String> secondSelection;
  final List<String> partnersOrConsultants;
  final List<String> opportunitiesTitles;

  const MainViewBody({
    super.key,
    required this.firstSelection,
    required this.secondSelection,
    required this.partnersOrConsultants,
    required this.opportunitiesTitles,
  });

  @override
  State<MainViewBody> createState() => _MainViewBodyState();
}

class _MainViewBodyState extends State<MainViewBody> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScroll);

  ValueNotifier<String> get firstSelection => widget.firstSelection;
  ValueNotifier<String> get secondSelection => widget.secondSelection;
  List<String> get _partnersOrConsultants => widget.partnersOrConsultants;
  List<String> get _opportunitiesTitles => widget.opportunitiesTitles;

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<GetOpportunitiesCubit>();
      if (cubit.canLoadMore) {
        cubit.loadMoreOpportunities(type: secondSelection.value.toUserGender());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    firstSelection.addListener(_firstSelectionListener);
    secondSelection.addListener(_secondSelectionListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _firstSelectionListener() {
    if (firstSelection.value == _partnersOrConsultants.first) {
      secondSelection.value = _opportunitiesTitles.first;
    }
  }

  void _secondSelectionListener() {
    context.read<GetOpportunitiesCubit>().getOpportunities(
          type: secondSelection.value.toUserGender(),
          page: 1,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPromoted = context.select(
      (UserCubit cubit) => cubit.user.isPromoted,
    );

    return BlocProvider(
      create: (context) => MainViewCubit()..getHomeData(),
      child: BlocBuilder<MainViewCubit, AsyncState<HomeModel>>(
        builder: (context, state) => SliverCenterCardScaffold(
          scrollController: _scrollController,
          bodyTopPadding: 120,
          cardTopPadding: 100,
          upperWidget: const HomeWelcomeHeader(),
          bodyColor: Colors.white,
          upperWidgetPadding: const EdgeInsets.all(20),
          centerCardBody: StatusBuilder(
            data: state,
            onSuccess: (data, context) => ImageSlider(
              height: context.height / 5,
              images:
                  state.data.banners?.map((e) => e.image ?? '').toList() ?? [],
            ),
          ),
          headerContent: Column(
            children: [
              if (!isPromoted) ...[
                const PromotionBadge(),
                SizedBox(height: 16.h),
              ],
              StatusBuilder(
                data: state,
                onSuccess: (data, context) => Column(
                  children: [
                    ChooseFromOptionsWidget(
                      onSelectOption: (selectedOption) =>
                          firstSelection.value = selectedOption,
                      fontSize: 14.sp,
                      childPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 12.w,
                      ),
                      titles: _partnersOrConsultants,
                    ),
                    ValueListenableBuilder(
                      valueListenable: firstSelection,
                      builder: (context, value, child) =>
                          value == _partnersOrConsultants.first
                              ? ChooseFromOptionsWidget(
                                  fontWeight: FontWeight.w500,
                                  onSelectOption: (selectedOption) =>
                                      secondSelection.value = selectedOption,
                                  childPadding:
                                      EdgeInsets.symmetric(vertical: 12.h),
                                  titles: _opportunitiesTitles,
                                  fontSize: 14.sp,
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bodyBuilder: (context) => ValueListenableBuilder(
            valueListenable: firstSelection,
            builder: (context, value, child) =>
                value == _partnersOrConsultants.first
                    ? OpportunitiesListBody(secondSelection: secondSelection)
                    : ConsultantsListBody(
                        consultants: state.data.marriageConsultants),
          ),
        ),
      ),
    );
  }
}
