import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/auth/imports.dart';
import '../../features/auth/presentation/cubits/add_child.dart';
import '../../features/main_screen/data/models/home_model.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../extensions/num.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/parent/parent_model.dart';
import '../shared/models/user_models/user_model.dart';
import 'buttons/custom_app_buttons/default_button.dart' show AppDefaultButton;
import 'parent_children.dart' show ParentChildren, ChildCard;
import 'scaffolds/app_scaffold.dart';

class ParentChildrenView extends StatelessWidget {
  const ParentChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    final PagifyController<Opportunity> cont = PagifyController<Opportunity>();
    return AppScaffold(
      appBarTitle: LocaleKeys.children,
      body: ParentChildren(
          cont: cont,
          type: IndividualDetailsType.myChild,
          childCard: ChildCard.sub
      ),
      bottomBar: AppDefaultButton.withBackGroundColor(
          title: LocaleKeys.addAnotherChild,
          onTap: () => Go.to(BlocProvider(
            create: (context) => AddChildCubit(),
            child: EnterMaleOrFemaleOrChildDataScreen.showAll(
                scaffoldType: ScaffoldType.appScaffold,
                maleNum: (UserModel.currentUser as ParentModel).maleChildrenNum,
                femaleNum: (UserModel.currentUser as ParentModel).femaleChildrenNum,
                onClick: (context, user) async => await context.read<AddChildCubit>().addChild(
                    body: user,
                    cancelOnTap: () => 3.pop()
                ),
            ),
          ),)
      ).paddingAll(12.r),
    );
  }
}