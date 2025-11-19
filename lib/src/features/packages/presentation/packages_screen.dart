import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../core/widgets/app_pagify.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/pull_refresher.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../core/widgets/sheets/payment_sheet.dart';
import '../data/packages_data.dart';
import '../models/package.dart';
import 'widgets/package_widget.dart';

enum ScreenType{first, renew}

class PackagesScreen extends StatelessWidget {
  final ScreenType type;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;

  const PackagesScreen.subscription({super.key,
    this.isInAuth = false,
    this.paymentMethods,
  }) : type = ScreenType.first;
  const PackagesScreen.renew({super.key,
    required this.isInAuth,
    this.paymentMethods,
  }) : type = ScreenType.renew;


  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> random = ValueNotifier(Random().nextDouble());
    return AppScaffold(
        appBarTitle: LocaleKeys.packages,
        onRefresh: (context) => random.value = Random().nextDouble(),
        body: Column(
          children: [
            AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),
            ValueListenableBuilder(
              valueListenable: random,
              builder: (context, val, child) => AppPagify<Package>(
                  key: UniqueKey(),
                  asyncCall: (ctx, page) async => await PackagesData.getPackages(),
                  itemBuilder: (ctx, data, index, element) => PackageWidget(
                    type: type,
                    paymentMethods: paymentMethods,
                    isInAuth: isInAuth,
                    package: element,
                  ),
                  pagifyController: PagifyController<Package>(),
              ),
            )
          ],
        )
    );
  }
}
