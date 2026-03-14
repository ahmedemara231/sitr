import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'package:pagify/pagify.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/socket_service/client_io.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/sheets/delete_sheet.dart';
import '../../../chats/data/chat_notification_service.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../../chats/data/models/message_params_model.dart';
import '../../../chats/data/socket_events.dart';
import '../../../chats/presentation/cubits/notification_cubit.dart';
import '../../../chats/presentation/cubits/socket_cubit.dart';
import '../../data/models/notification_model.dart';
import '../../data/notification_data.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocketCubit(),
      child: const NotificationBody(),
    );
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  late PagifyController<NotificationModel> controller = PagifyController<NotificationModel>();
  late SocketHelper _socketHelper;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  void _initSocket() {
    _socketHelper = ClientIOImpl(
      onConnect: (d) => log('notifications socket connected'),
      onDisconnect: (d) => log('notifications socket disconnected'),
      onReconnect: (d) => log('notifications socket reconnected'),
      extraParams: MessageParamsModel().toJson(),
      url: ConstantManager.socketUrl,
      roomId: 0,
      jsonToChatMessage: (_) => throw UnimplementedError(),
      onReceiveMessage: (_) {},
      events: EasyChatEvents(
        messageEvents: MessageEvents(
          receiveMsgEvent: SocketEvents.receivedMsg,
          sendMsgEvent: SocketEvents.sendMsg,
        ),
        chatEvents: ChatEvents(
          enterChatEvent: SocketEvents.enterChat,
          exitChatEvent: SocketEvents.exitChat,
        ),
        otherEvents: [],
      ),
    )..initSocket()..initConfig()..connect();
    context.read<SocketCubit>().setSocket(_socketHelper);
  }

  void _fireShouldUpdate({required int roomId, required int matchRequestId, required int receiverId}) {
    context.read<SocketCubit>().fireShouldUpdate(
      roomId: roomId,
      matchRequestId: matchRequestId,
      receiverId: receiverId,
    );
  }

  @override
  void dispose() {
    _socketHelper.disconnect();
    controller.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _showDeleteAll = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(
          injector<ChatNotificationService>()
      ),
      child: AppScaffold(
        isScrollable: false,
        appBarTitle: LocaleKeys.notifications,
        actions: [
          ValueListenableBuilder(
              valueListenable: _showDeleteAll,
              builder: (context, show, child) => show? IconWidget(
                icon: Assets.svgTrashIcon,
                onTap: () {
                  ChatSheetManager.show(
                    child: DeleteSheet(
                      asyncCall: (context) async {
                        final res = await NotificationsData.deleteAllNotification();
                        if (res.isSuccess()) {
                          controller.clear();
                          Go.back();
                          MessageUtils.showSnackBar(res.getOrThrow().msg);
                        }
                      },
                      title: LocaleKeys.areYouSureToDeleteAllNotifications,
                    ),
                  );
                },
              ) : const SizedBox.shrink(),
          ),
        ],
        body: AppPagify<NotificationModel>(
          key: UniqueKey(),
          asyncCall: (context, page)async => await NotificationsData.getNotifications(page),
          cacheKey: 'notifications',
          cacheToJson: (item) => item.toJson(),
          cacheFromJson: (json) => NotificationModel.fromJson(json),
          onUpdateStatus: (state) {
            if(state.isSuccess){
              _showDeleteAll.value = controller.getItemsLength > 1;
            }
          },
          itemBuilder: (context, data, index, element) => NotificationCard(
            notificationModel: element,
            onFireShouldUpdate: ({required int roomId, required int matchRequestId, required int receiverId}) {
              _fireShouldUpdate(roomId: roomId, matchRequestId: matchRequestId, receiverId: receiverId);
            },
            onDelete: (id) async {
              ChatSheetManager.show(
                child: DeleteSheet(
                  asyncCall: (context) async {
                    final res = await NotificationsData.deleteNotification(id);
                    if (res.isSuccess()) {
                      controller.removeWhere((e) => e.id == id);
                      Go.back();
                      MessageUtils.showSnackBar(res.getOrThrow().msg);
                    }
                  },
                  title: LocaleKeys.areYouSureToDeleteThisNotification,
                ),
              );
            },
          ).paddingBottom(10.h),
          pagifyController: controller,
        ).defaultScreenPadding().withPullRefresher(onRefresh: () {
          controller.refresh();
        }),
      ),
    );
  }
}

