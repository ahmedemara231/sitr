import 'package:flutter/material.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../core/extensions/sized_box_helper.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import 'widgets/package_widget.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

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
                itemBuilder: (context, index) => const PackageWidget(),
                separatorBuilder:  (context, index) => 5.szH,
                itemCount: 3
            ),
          ],
        )
    );
  }
}
