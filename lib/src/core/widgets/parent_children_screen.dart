import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/auth/imports.dart';
import '../../features/auth/presentation/cubits/add_child.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import 'buttons/custom_app_buttons/default_button.dart' show AppDefaultButton;
import 'parent_children.dart' show ParentChildren;
import 'scaffolds/app_scaffold.dart';

class ParentChildrenView extends StatelessWidget {
  const ParentChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: LocaleKeys.children,
      body: const ParentChildren(type: IndividualDetailsType.myChild),
      bottomBar: AppDefaultButton.withBackGroundColor(
          title: LocaleKeys.addAnotherChild,
          onTap: () => Go.to(BlocProvider(
            create: (context) => AddChildCubit(),
            child: EnterMaleOrFemaleOrChildDataScreen.withParent(
                scaffoldType: ScaffoldType.appScaffold,
                onClick: (context, user) async => await context.read<AddChildCubit>().addChild(
                    body: user,
                    onSuccess: () {}
                ),
            ),
          ),)
      ).paddingAll(12.r),
    );
  }
}