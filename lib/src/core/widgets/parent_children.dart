import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../features/auth/imports.dart';
import '../../features/main_screen/data/home_data.dart';
import '../../features/main_screen/data/models/home_model.dart';
import '../../features/main_screen/presentation/cubits/get_partner_info_cubit.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../../features/main_screen/presentation/widgets/home/partner_card.dart';
import '../../features/more/presentation/cubit/edit_child_data_cubit.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import 'app_pagify.dart';
import 'parent_children_card.dart';


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

          child: BlocProvider(
            create: (context) => GetPartnerInfoCubit(element.id!),
            child: ParentChildrenCard(
                onEditTap: (context) => context.read<GetPartnerInfoCubit>().getProfile(
                    onSuccess: (user) => Go.to(BlocProvider(
                        create: (context) => EditChildDataCubit(),
                      child: EnterMaleOrFemaleOrChildDataScreen.withParent(
                          scaffoldType: ScaffoldType.appScaffold,
                          initialValue: user as IndividualUserModel,
                          showGenderSelection: false,
                          onClick: (context, user)async => await context.read<EditChildDataCubit>().editChildData(user),
                          userType: element.gender?.userType
                      ),
                    )),
                ),
                name: element.name,
                url: element.avatar
            ),
          ),

          // child: PartnerCard(
          //   name: element.name??'',
          //   imageUrl: element.avatar??'',
          //   location: element.city??'',
          //   weight: element.weight.toString(),
          //   height: element.height.toString(),
          //   age: element.age ?? 0,
          //   maritalStatus: element.name??'',
          //   onEditDataTap: () => Go.to(EnterMaleOrFemaleOrChildDataScreen.individual(
          //       scaffoldType: ScaffoldType.appScaffold,
          //       // initialValue: element, // جيب الداتا الاول بعدين خش اعمل edit
          //       onClick: (context, user)async{}, // edit child data endpoint
          //       userType: element.gender?.userType
          //   )),
          // ).paddingBottom(10.h),
        ),
        pagifyController: PagifyController()
    );
  }
}
