import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../features/main_screen/data/home_data.dart';
import '../../features/main_screen/data/models/home_model.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../../features/main_screen/presentation/widgets/home/partner_card.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import 'app_pagify.dart';


class ParentChildren extends StatelessWidget {
  final int? id;
  final IndividualDetailsType type;

  const ParentChildren({
    super.key,
    this.id,
    required this.type,
  });

  Widget _individualDetailsScreenRoute(int id){
    if(type == IndividualDetailsType.myChild){
      return IndividualDetailsScreen.myChildProfile(
        id: id,
      );

    }else if(type == IndividualDetailsType.profile){
      return IndividualDetailsScreen.profile(
        id: id,
      );

    }else{
      return IndividualDetailsScreen.opportunity(
        id: id,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return AppPagify<Opportunity>(
        asyncCall: (context, page)async => await HomeData.getParentChildren(id),
        itemBuilder: (context, data, index, element) => InkWell(
          onTap: () => Go.to(_individualDetailsScreenRoute(element.id ?? 0)),
          child: PartnerCard(
              name: element.name??'',
              imageUrl: element.avatar??'',
              location: element.city??'',
              weight: element.weight.toString(),
              height: element.height.toString(),
              age: element.age ?? 0,
              maritalStatus: element.name??''
          ).paddingBottom(10.h),
        ),
        pagifyController: PagifyController()
    );
  }
}
