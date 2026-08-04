import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/sheets/payment_sheet.dart';
import '../../data/packages_data.dart';
import '../../models/package.dart';
import '../models/package_screen_type.dart';
import 'package_widget.dart';

class PackagesBody extends StatelessWidget {
  final PagifyController<Package> controller;
  final ScreenType type;
  final UserType? userType;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;

  const PackagesBody({
    required this.controller,
    required this.type,
    required this.isInAuth,
    this.userType,
    this.paymentMethods,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (UserModel.currentUser?.type?.userType?.isChild ?? false) {
      return const NotContainData();
    }

    return Column(
      children: [
        if (isInAuth)
          AppText(
            LocaleKeys
                .inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages,
            textAlign: TextAlign.center,
          ),
        Expanded(
          child: AppPagify<Package>(
            asyncCall: (BuildContext context, int page) =>
                PackagesData.getPackages(page: page, userType: userType),
            cacheKey: 'packages_${userType?.name ?? 'all'}',
            cacheToJson: (Package item) => item.toJson(),
            cacheFromJson: (Map<String, dynamic> json) =>
                Package.fromJson(json),
            itemBuilder: (_, __, ___, Package package) => PackageWidget(
              type: type,
              paymentMethods: paymentMethods,
              isInAuth: isInAuth,
              package: package,
              onSubscribe: controller.refresh,
            ),
            pagifyController: controller,
          ).withPullRefresher(onRefresh: controller.refresh),
        ),
      ],
    );
  }
}
