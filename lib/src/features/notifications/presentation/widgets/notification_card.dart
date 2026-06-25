import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
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
  // Design tokens mapped from the React/Tailwind card.
  static const Color _amber50 = Color(0xFFFFFBEB); // bg-amber-50
  static const Color _amber200 = Color(0xFFFDE68A); // border-amber-200
  static const Color _gray900 = Color(0xFF111827); // title
  static const Color _gray700 = Color(0xFF374151); // subtitle
  static const Color _gray400 = Color(0xFF9CA3AF); // time
  static const Color _gray100 = Color(0xFFF3F4F6); // card border
  static const Color _gray50 = Color(0xFFF9FAFB); // bottom divider
  static const Color _red500 = Color(0xFFEF4444); // delete icon

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

  Container _stateContainer(ButtonsState state) {
    return Container(
      decoration: BoxDecoration(
        color: state.isAccepted ? Colors.green.withOpacity(.4) : Colors.red.withOpacity(.4),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Center(child: AppText(state.isAccepted ? LocaleKeys.accepted : LocaleKeys.rejected).paddingAll(10.r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          widget.notificationModel.type.getType.navigation
              .navigate(data: widget.notificationModel.data!);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: _gray100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Right: Icon
                  Container(
                    width: 48.w,
                    height: 48.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _amber50,
                      shape: BoxShape.circle,
                      border: Border.all(color: _amber200, width: 2),
                    ),
                    child: SvgPicture.asset(
                      Assets.svgNotificationWidgetIcon,
                      width: 22.w,
                      height: 22.w,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Middle: Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.notificationModel.title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: _gray900,
                          height: 1.3,
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          widget.notificationModel.body,
                          fontSize: 10.sp,
                          color: _gray700,
                          height: 1.5,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Accept / reject (first stage) state
              ValueListenableBuilder<ButtonsState?>(
                valueListenable: _buttonsState,
                builder: (context, state, _) {
                  if (state!.isAccepted || state.isRejected) {
                    return _stateContainer(state).paddingOnly(top: 12.h);
                  } else if (state.isShow) {
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
                                },
                              );
                            },
                          ).paddingOnly(top: 12.h);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              // Bottom row: time + delete
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Column(
                  children: [
                    const Divider(height: 1, thickness: 1, color: _gray50),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          onTap: () async => widget.onDelete.call(widget.notificationModel.id),
                          child: SvgPic(
                            assetName: Assets.svgTrashIcon,
                            color: _red500,
                            size: 18.sp,
                          ),
                        ),
                        AppText(
                          widget.notificationModel.createdAt,
                          fontSize: 11.sp,
                          color: _gray400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
