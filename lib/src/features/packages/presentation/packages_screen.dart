import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../core/extensions/widget_extension.dart';
import '../../../core/helpers/user_type_enum.dart';
import '../../../core/shared/models/user_models/user_model.dart';
import '../../../core/widgets/app_pagify.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/not_contain_data.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../core/widgets/sheets/payment_sheet.dart';
import '../data/packages_data.dart';
import '../models/package.dart';
import 'widgets/package_widget.dart';

enum ScreenType{subscription, renew}

class PackagesScreen extends StatefulWidget {
  final ScreenType type;
  final UserType? userType;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;

  const PackagesScreen.subscription({super.key,
    this.isInAuth = false,
    this.paymentMethods,
    this.userType,
  }) : type = ScreenType.subscription;

  const PackagesScreen.renew({super.key,
    this.paymentMethods,
  }) : type = ScreenType.renew, userType = null, isInAuth = false;

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late final PagifyController<Package> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PagifyController<Package>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isScrollable: false,
        appBarTitle: LocaleKeys.packages,
        body: UserModel.currentUser?.type?.userType?.isChild ?? false
        ? const NotContainData()
        : Column(
          children: [
            if(widget.isInAuth)
              AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),
            Expanded(
              child: AppPagify<Package>(
                  asyncCall: (ctx, page) async => await PackagesData.getPackages(page: page, userType: widget.userType),
                  cacheKey: 'packages_${widget.userType?.name ?? 'all'}',
                  cacheToJson: (item) => item.toJson(),
                  cacheFromJson: (json) => Package.fromJson(json),
                  itemBuilder: (ctx, data, index, element) => PackageWidget(
                    type: widget.type,
                    paymentMethods: widget.paymentMethods,
                    isInAuth: widget.isInAuth,
                    package: element,
                  ),
                  pagifyController: _controller,
              ).withPullRefresher(
                onRefresh: () => _controller.refresh(),
              ),
            )
          ],
        )
    );
  }
}
