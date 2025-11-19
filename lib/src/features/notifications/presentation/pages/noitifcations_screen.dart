import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/notification_data.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationBody();
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> random = ValueNotifier(Random().nextDouble());
    return AppScaffold(
      onRefresh: (context) => random.value = Random().nextDouble(),
      appBarTitle: LocaleKeys.notifications,
      body: ValueListenableBuilder(
        valueListenable: random,
        builder: (context, value, child) => AppPagify(
            key: UniqueKey(),
            asyncCall: (context, page) => NotificationsData.getNotifications(page),
            itemBuilder: (context, data, index, element) => NotificationCard(notificationModel: element),
            pagifyController: PagifyController()
        ).defaultScreenPadding(),
      ),
    );
  }
}
