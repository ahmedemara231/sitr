import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/home_data.dart';
import '../../data/models/filter_model.dart';
import '../widgets/home/partner_card.dart';
import 'partner_details.dart';

class FilterResultScreen extends StatelessWidget {
  final FilterModel filterModel;
  const FilterResultScreen({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> random = ValueNotifier(Random().nextDouble());
    return AppScaffold(
        onRefresh: (c) => random.value = Random().nextDouble(),
        appBarTitle: LocaleKeys.searchResult,
        body: ValueListenableBuilder(
          valueListenable: random,
          builder: (context, value, child) => AppPagify(
            key: UniqueKey(),
            pagifyController: PagifyController(),
            asyncCall: (context, page) async => await HomeData.filter(filterModel),
            itemBuilder: (context, data, i, opportunity) => InkWell(
              onTap: () => Go.to(IndividualDetailsScreen.opportunity(
                id: opportunity?.id ?? 0,
              )),
              child: PartnerCard.individual(opportunity: opportunity).paddingBottom(10.h),
          )),
        )
    );
  }
}
