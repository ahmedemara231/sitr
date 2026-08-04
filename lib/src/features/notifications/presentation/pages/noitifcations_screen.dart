import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'package:pagify/pagify.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/delete_sheet.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../data/models/notification_model.dart';
import '../../data/notification_data.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const NotificationBody();
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  late final PagifyController<NotificationModel> _controller;
  late final ValueNotifier<bool> _showDeleteAll;

  @override
  void initState() {
    super.initState();
    _controller = PagifyController<NotificationModel>();
    _showDeleteAll = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _showDeleteAll.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: false,
      appBarTitle: LocaleKeys.notifications,
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _showDeleteAll,
          builder: (context, show, child) {
            if (!show) return const SizedBox.shrink();
            return IconWidget(
              icon: Assets.svgTrashIcon,
              onTap: _showDeleteAllSheet,
            ).paddingAll(3.r);
          },
        ),
      ],
      body: AppPagify<NotificationModel>(
        asyncCall: (_, page) => NotificationsData.getNotifications(page),
        cacheKey: 'notifications',
        cacheToJson: (item) => item.toJson(),
        cacheFromJson: (json) => NotificationModel.fromJson(json),
        onUpdateStatus: (state) {
          if (state.isSuccess) {
            _showDeleteAll.value = _controller.getItemsLength > 1;
          }
        },
        itemBuilder: (_, data, index, notification) {
          return NotificationCard(
            notificationModel: notification,
            onDelete: _showDeleteNotificationSheet,
          ).paddingBottom(10.h);
        },
        pagifyController: _controller,
      ).defaultScreenPadding().withPullRefresher(
            onRefresh: () => _controller.refresh(),
          ),
    );
  }

  void _showDeleteAllSheet() {
    ChatSheetManager.show(
      child: DeleteSheet(
        asyncCall: (context) async {
          final result = await NotificationsData.deleteAllNotification();
          if (result.isSuccess()) {
            _controller.clear();
            Go.back();
            MessageUtils.show(
              result.getOrThrow().msg,
              state: MsgState.success,
            );
          }
        },
        title: LocaleKeys.areYouSureToDeleteAllNotifications,
      ),
    );
  }

  Future<void> _showDeleteNotificationSheet(String id) async {
    ChatSheetManager.show(
      child: DeleteSheet(
        asyncCall: (context) async {
          final result = await NotificationsData.deleteNotification(id);
          if (result.isSuccess()) {
            _controller.removeWhere((item) => item.id == id);
            Go.back();
            MessageUtils.show(
              result.getOrThrow().msg,
              state: MsgState.success,
            );
          }
        },
        title: LocaleKeys.areYouSureToDeleteThisNotification,
      ),
    );
  }
}
