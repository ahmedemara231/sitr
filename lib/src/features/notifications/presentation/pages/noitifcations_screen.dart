import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'package:pagify/pagify.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/delete_sheet.dart';
import '../../data/models/notification_model.dart';
import '../../data/notification_data.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationBody();
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  late PagifyController<NotificationModel> controller;
  late ValueNotifier<double> random;

  @override
  void initState() {
    super.initState();
    controller = PagifyController<NotificationModel>();
    random = ValueNotifier(Random().nextDouble());
  }

  @override
  void dispose() {
    random.dispose();
    controller.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _showDeleteAll = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onRefresh: (context) {
        controller = PagifyController<NotificationModel>();
        random.value = Random().nextDouble();
      },
      appBarTitle: LocaleKeys.notifications,
      actions: [
        ValueListenableBuilder(
            valueListenable: _showDeleteAll,
            builder: (context, show, child) => show? IconWidget(
              icon: Assets.svgTrashIcon,
              onTap: () {
                showDefaultBottomSheet(
                  child: DeleteSheet(
                    asyncCall: (context) async {
                      final res = await NotificationsData.deleteAllNotification();
                      if (res.isSuccess()) {
                        controller.clear();
                        Go.back();
                      }
                    },
                    title: LocaleKeys.areYouSureToDeleteAllNotifications,
                  ),
                );
              },
            ) : const SizedBox.shrink(),
        ),
      ],
      body: ValueListenableBuilder(
        valueListenable: random,
        builder: (context, value, child) => AppPagify<NotificationModel>(
          key: UniqueKey(),
          asyncCall: (context, page) => NotificationsData.getNotifications(page),
          onUpdateStatus: (state) {
            if(state.isSuccess){
              _showDeleteAll.value = controller.getItemsLength >= 2;
            }
          },
          itemBuilder: (context, data, index, element) => NotificationCard(
            notificationModel: element,
            onDelete: (id) async {
              showDefaultBottomSheet(
                child: DeleteSheet(
                  asyncCall: (context) async {
                    final res = await NotificationsData.deleteNotification(id);
                    if (res.isSuccess()) {
                      controller.removeWhere((e) => e.id == id);
                      Go.back();
                    }
                  },
                  title: LocaleKeys.areYouSureToDeleteThisNotification,
                ),
              );
            },
          ).paddingBottom(10.h),
          pagifyController: controller,
        ).defaultScreenPadding(),
      ),
    );
  }
}

