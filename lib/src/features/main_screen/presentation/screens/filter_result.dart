import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/home_data.dart';
import '../../data/models/filter_model.dart';
import '../../data/models/home_model.dart';
import '../widgets/home/partner_card.dart';
import 'partner_details.dart';

class FilterResultScreen extends StatefulWidget {
  final FilterModel filterModel;
  const FilterResultScreen({super.key, required this.filterModel});

  @override
  State<FilterResultScreen> createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  late final PagifyController<Opportunity> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PagifyController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isScrollable: false,
        appBarTitle: LocaleKeys.searchResult,
        body: AppPagify<Opportunity>(
          pagifyController: _controller,
          asyncCall: (context, page) async => await HomeData.filter(widget.filterModel, page),
          cacheKey: 'filter_result',
          cacheToJson: (item) => item.toJson(),
          cacheFromJson: (json) => Opportunity.fromJson(json),
          itemBuilder: (context, data, i, opportunity) => InkWell(
            onTap: () => Go.to(IndividualDetailsScreen.opportunity(
              id: opportunity.id ?? 0,
            )),
            child: InkWell(
                onTap: () => UserModel.isAuthenticated
                    ? Go.to(
                      IndividualDetailsScreen.opportunity(id: opportunity.id ?? 0),
                )
                    : Helpers.showUnauthenticatedSheet(),
                child: PartnerCard.individual(opportunity: opportunity).paddingBottom(10.h)),
        )).withPullRefresher(
          onRefresh: () => _controller.refresh(),
        ),
    );
  }
}
