import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../core/widgets/app_pagify.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../data/packages_data.dart';
import '../models/package.dart';
import 'widgets/package_widget.dart';

enum ScreenType{first, renew}

class PackagesScreen extends StatelessWidget {
  final ScreenType type;
  final bool isInAuth;

  const PackagesScreen.firstSubscription({super.key,
    this.isInAuth = false,
  }) : type = ScreenType.first;
  const PackagesScreen.renew({super.key,
    required this.isInAuth,
  }) : type = ScreenType.renew;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarTitle: LocaleKeys.packages,
        body: Column(
          children: [
            AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),
            AppPagify<Package>(
                asyncCall: (ctx, page) async => await PackagesData.getPackages(),
                itemBuilder: (ctx, data, index, element) => PackageWidget(
                  type: type,
                  package: element,
                  isInAuth: isInAuth,
                ),
                pagifyController: PagifyController()
            )
          ],
        )
    );
  }
}
