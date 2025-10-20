import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/language/locale_keys.g.dart';
import '../extensions/padding_extension.dart';
import 'buttons/custom_app_buttons/default_button.dart' show AppDefaultButton;
import 'parent_children.dart' show ParentChildren;
import 'scaffolds/app_scaffold.dart';

class ParentChildrenView extends StatelessWidget {
  final int id;
  const ParentChildrenView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: LocaleKeys.children,
      body: ParentChildren(id: id),
      bottomBar: AppDefaultButton.withBackGroundColor(
          title: LocaleKeys.addAnotherChild,
          onTap: () {}
      ).paddingAll(12.r),
    );
  }
}