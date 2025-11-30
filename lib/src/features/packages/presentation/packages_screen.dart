import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/extensions/widget_extension.dart';
import '../../../core/helpers/user_type_enum.dart';
import '../../../core/widgets/app_pagify.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../core/widgets/sheets/payment_sheet.dart';
import '../data/packages_data.dart';
import '../models/package.dart';
import 'widgets/package_widget.dart';

enum ScreenType{first, renew}

class PackagesScreen extends StatelessWidget {
  final ScreenType type;
  final UserType? userType;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;

  const PackagesScreen.subscription({super.key,
    this.isInAuth = false,
    this.paymentMethods,
    this.userType,
  }) : type = ScreenType.first;
  const PackagesScreen.renew({super.key,
    required this.isInAuth,
    this.paymentMethods,
  }) : type = ScreenType.renew, userType = null;


  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> random = ValueNotifier(Random().nextDouble());
    return AppScaffold(
        isScrollable: false,
        appBarTitle: LocaleKeys.packages,
        body: Column(
          children: [
            if(isInAuth)
              AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),
            ValueListenableBuilder(
              valueListenable: random,
              builder: (context, val, child) => SizedBox(
                height: context.height * 0.7,
                child: AppPagify<Package>(
                    key: UniqueKey(),
                    asyncCall: (ctx, page) async => await PackagesData.getPackages(page: page, userType: userType),
                    itemBuilder: (ctx, data, index, element) => PackageWidget(
                      type: type,
                      paymentMethods: paymentMethods,
                      isInAuth: isInAuth,
                      package: element,
                    ),
                    pagifyController: PagifyController<Package>(),
                ).withPullRefresher(
                  onRefresh: () => random.value = Random().nextDouble(),
                ),
              ),
            )
          ],
        )
    );
  }
}
