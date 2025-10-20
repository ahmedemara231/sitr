import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/main_screen/presentation/screens/partner_details.dart';
import '../extensions/padding_extension.dart';
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
          onTap: () {}
      ).paddingAll(12.r),
    );
  }
}