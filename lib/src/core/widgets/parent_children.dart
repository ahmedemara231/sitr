import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/auth/imports.dart';
import '../../features/main_screen/data/home_data.dart';
import '../../features/main_screen/data/models/home_model.dart';
import '../../features/main_screen/presentation/cubits/get_partner_info_cubit.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../../features/main_screen/presentation/widgets/home/partner_card.dart';
import '../../features/more/presentation/cubit/delete_child_cubit.dart';
import '../../features/more/presentation/cubit/edit_child_data_cubit.dart';
import '../extensions/num.dart';
import '../extensions/padding_extension.dart';
import '../extensions/widget_extension.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import 'app_pagify.dart';
import 'custom_messages.dart';
import 'default_bottom_sheet.dart';
import 'parent_children_card.dart';
import 'sheets/delete_sheet.dart';

enum ChildCard{sub, full}
class ParentChildren extends StatefulWidget {
  final int? id;
  final IndividualDetailsType type;
  final ChildCard childCard;
  final PagifyController<Opportunity>? cont;

  const ParentChildren({
    super.key,
    this.id,
    required this.type,
    this.cont,
    this.childCard = ChildCard.full
  });

  @override
  State<ParentChildren> createState() => _ParentChildrenState();
}

class _ParentChildrenState extends State<ParentChildren> {
  Widget _individualDetailsScreenRoute(int id){
    if(widget.type == IndividualDetailsType.myChild){
      return IndividualDetailsScreen.myChildProfile(
        id: id,
      );

    }else if(widget.type == IndividualDetailsType.profile){
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
    final PagifyController<Opportunity> childrenCont = widget.cont ?? PagifyController();
    return AppPagify<Opportunity>(
        asyncCall: (context, page)async => await HomeData.getParentChildren(widget.id, page),
        itemBuilder: (context, data, index, element) => InkWell(
          onTap: () => Go.to(_individualDetailsScreenRoute(element.id ?? 0)),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => GetPartnerInfoCubit(element.id!)),
              BlocProvider(create: (context) => DeleteChildCubit()),
            ],
            child: widget.childCard == ChildCard.sub?
            ParentChildrenCard(
                onEditTap: (context) => context.read<GetPartnerInfoCubit>().getProfile(
                  onSuccess: (user) => Go.to(BlocProvider(
                    create: (context) => EditChildDataCubit(),
                    child: EnterMaleOrFemaleOrChildDataScreen.showAll(
                        scaffoldType: ScaffoldType.appScaffold,
                        initialValue: user as IndividualUserModel,
                        showGenderSelection: false,
                        onClick: (context, user)async => await context.read<EditChildDataCubit>().editChildData(
                            user,
                          onSuccess: (data) {
                             2.pop();
                              MessageUtils.showSnackBar(data.msg);
                          }
                        ),
                    ),
                  )),
                ),
                onDeleteTap: (context) => showDefaultBottomSheet(
                    child: BlocProvider(
                      create: (context) => DeleteChildCubit(),
                      child: DeleteSheet(
                          asyncCall: (ctx) => ctx.read<DeleteChildCubit>().execute(
                              id: element.id??0,
                              onSuccess: (msg) {
                                Go.back();
                                MessageUtils.showSnackBar(msg);
                                childrenCont.refresh();
                              }
                          ),
                          title: '${LocaleKeys.areYouSureToDelete} ${element.name}'),
                    )
                ),
                name: element.name,
                url: element.avatar
            ).paddingBottom(16.h) :
            PartnerCard.withParent(opportunity: element).paddingBottom(10.h),
          ),


        ),
        pagifyController: childrenCont
    ).withPullRefresher(
      onRefresh: () => childrenCont.refresh()
    );
  }
}
