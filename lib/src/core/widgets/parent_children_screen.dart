import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/auth/imports.dart';
import '../../features/auth/presentation/cubits/add_child.dart';
import '../../features/auth/presentation/widgets/sign_up/sheets/add_child_sheet.dart';
import '../../features/main_screen/data/models/home_model.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../extensions/num.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/individual/female_model.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/parent/parent_model.dart';
import '../shared/user_cubit/user_cubit.dart';
import 'buttons/custom_app_buttons/default_button.dart' show AppDefaultButton;
import 'default_bottom_sheet.dart';
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
                onClick: (context, user) async => await context.read<AddChildCubit>().addChild(
                    body: user,
                    onSuccess: (data) {
                      // final user = data.data as IndividualUserModel;
                      // final Opportunity opportunity = Opportunity(
                      //   id: user.id,
                      //   name: user.name,
                      //   avatar: user.avatar,
                      // );

                      showDefaultBottomSheet(
                          child: AddChildSheet(cancelOnTap: () {
                            // cont.addItem(opportunity);
                            3.pop();
                          })
                      );
                    }
                ),
            ),
          ),)
      ).paddingAll(12.r),
    );
  }
}