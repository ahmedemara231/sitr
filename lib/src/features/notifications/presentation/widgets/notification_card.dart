import 'dart:developer';

import 'package:dropinity/helpers/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../chats/data/models/request_model.dart';
import '../../../chats/presentation/cubits/start_chat.dart';
import '../../../chats/presentation/widgets/accept_or_reject_first_stage.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notificationModel;
  final Future<void> Function(String id) onDelete;
  final void Function({required int roomId, required int matchRequestId, required int receiverId})? onFireShouldUpdate;

  const NotificationCard({super.key,
    required this.onDelete,
    required this.notificationModel,
    this.onFireShouldUpdate,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late final ValueNotifier<ButtonsState?> _buttonsState;

  @override
  void initState() {
    super.initState();
    _buttonsState = ValueNotifier(widget.notificationModel.buttonsState);
  }

  @override
  void dispose() {
    _buttonsState.dispose();
    super.dispose();
  }

  Container _stateContainer(ButtonsState state){
    return Container(
      decoration: BoxDecoration(
          color: state.isAccepted? Colors.green.withOpacity(.4) : Colors.red.withOpacity(.4),
          borderRadius: BorderRadius.circular(7.r)
      ),
      child: Center(child: AppText(state.isAccepted? LocaleKeys.accepted : LocaleKeys.rejected).paddingAll(10.r)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.notificationModel.type.getType.navigation
            .navigate(data: widget.notificationModel.data!);
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.whiteGreyColorProMax,
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(Assets.svgNotificationWidgetIcon),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.notificationModel.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 7.h),
                      Text(
                        widget.notificationModel.body,
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    AppText(widget.notificationModel.createdAt, fontSize: 10.sp, color: Colors.grey),
                    IconButton(
                      onPressed: () async => widget.onDelete.call(widget.notificationModel.id),
                      icon: const SvgPic(assetName: Assets.svgTrashIcon)
                    )

                  ],
                )
              ],
            ),
            ValueListenableBuilder<ButtonsState?>(
              valueListenable: _buttonsState,
              builder: (context, state, _) {
                if(state!.isAccepted || state.isRejected) {
                  return _stateContainer(state);
                }
                else if(state.isShow){
                  return BlocProvider(
                    create: (_) => ChatCubit(),
                    child: Builder(
                      builder: (context) {
                        final data = widget.notificationModel.data!;
                        final matchRequestId = data['match_request_id'].toString();
                        final requestModel = RequestModel(
                          receiverId: data['sender_id'].toString(),
                          fromHome: 0.toString(),
                        );

                        return AcceptOrRejectFirstStageWidget(
                          showTitle: false,
                          onAccept: (ctx) async {
                            await ctx.read<ChatCubit>().executeRequestDirect(
                              requestModel: requestModel,
                              path: ApiConstants.acceptRequest + ApiConstants.userMoveToNextRequest,
                              matchRequestId: matchRequestId,
                              onSuccess: (chatModel) {
                                _buttonsState.value = ButtonsState.accepted;
                                widget.onFireShouldUpdate?.call(
                                  roomId: chatModel.room?.id ?? 0,
                                  matchRequestId: chatModel.matchRequest?.id ?? 0,
                                  receiverId: chatModel.room!.members!.first.id!,
                                );
                              },
                            );
                          },
                          onReject: (ctx) async {
                            await ctx.read<ChatCubit>().executeRequestDirect(
                              requestModel: requestModel,
                              path: ApiConstants.rejectAll,
                              matchRequestId: matchRequestId,
                              onSuccess: (chatModel) {
                                _buttonsState.value = ButtonsState.rejected;
                                widget.onFireShouldUpdate?.call(
                                  roomId: chatModel.room?.id ?? 0,
                                  matchRequestId: chatModel.matchRequest?.id ?? 0,
                                  receiverId: int.parse(data['sender_id'].toString()),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
