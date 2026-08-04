import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/helpers/user_type_enum.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../core/widgets/sheets/payment_sheet.dart';
import '../../../core/widgets/sheets/promotion_plans/promotion_plans_body.dart';
import '../../promotions/presentation/cubits/promotion_sheet_cubit.dart';
import '../../promotions/presentation/cubits/promotion_subscription_cubit.dart';
import '../models/package.dart';
import 'models/package_screen_type.dart';
import 'widgets/packages_body.dart';
import 'widgets/packages_tab_bar.dart';

export 'models/package_screen_type.dart';

class PackagesScreen extends StatefulWidget {
  final ScreenType type;
  final UserType? userType;
  final bool isInAuth;
  final List<PaymentMethod>? paymentMethods;
  final FutureOr<void> Function()? onSuccess;
  final int _initialTabIndex;

  const PackagesScreen.subscription({
    super.key,
    this.isInAuth = false,
    this.paymentMethods,
    this.userType,
  })  : type = ScreenType.subscription,
        onSuccess = null,
        _initialTabIndex = 0;

  const PackagesScreen.renew({
    super.key,
    this.paymentMethods,
  })  : type = ScreenType.renew,
        userType = null,
        isInAuth = false,
        onSuccess = null,
        _initialTabIndex = 0;

  const PackagesScreen.promotion({
    super.key,
    this.onSuccess,
  })  : type = ScreenType.subscription,
        userType = null,
        isInAuth = false,
        paymentMethods = null,
        _initialTabIndex = 1;

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late final PagifyController<Package> _controller;
  late int _currentTabIndex;

  bool get _showTabs => !widget.isInAuth && widget.type.isSubscription;

  @override
  void initState() {
    super.initState();
    _controller = PagifyController<Package>();
    _currentTabIndex = widget._initialTabIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showTabs) {
      return _buildPackagesScaffold();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PromotionSheetCubit()),
        BlocProvider(create: (_) => PromotionSubscriptionCubit()),
      ],
      child: AppScaffold(
        isScrollable: false,
        appBarTitle: LocaleKeys.packages,
        scaffoldBackgroundColor: AppColors.whiteScaffoldBackground,
        body: Column(
          children: [
            PackagesTabBar(
              currentIndex: _currentTabIndex,
              onTabChanged: _changeTab,
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _packagesBody,
                  PromotionPlansBody(onSuccess: widget.onSuccess),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesScaffold() {
    return AppScaffold(
      isScrollable: false,
      appBarTitle: LocaleKeys.packages,
      body: _packagesBody,
    );
  }

  Widget get _packagesBody => PackagesBody(
        controller: _controller,
        type: widget.type,
        userType: widget.userType,
        isInAuth: widget.isInAuth,
        paymentMethods: widget.paymentMethods,
      );

  void _changeTab(int index) {
    if (_currentTabIndex == index) return;
    setState(() => _currentTabIndex = index);
  }
}
