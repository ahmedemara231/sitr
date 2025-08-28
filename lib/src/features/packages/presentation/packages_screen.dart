import 'package:flutter/material.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../core/extensions/sized_box_helper.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import 'widgets/package_widget.dart';

enum ScreenType{view, subscribe}

class PackagesScreen extends StatelessWidget {
  final ScreenType type;

  const PackagesScreen.view({super.key}) : type = ScreenType.view;
  const PackagesScreen.subscribe({super.key}) : type = ScreenType.subscribe;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarTitle: LocaleKeys.packages,
        body: Column(
          children: [
            AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => PackageWidget(type: type),
                separatorBuilder:  (context, index) => 5.szH,
                itemCount: 3
            ),
          ],
        )
    );
  }
}
