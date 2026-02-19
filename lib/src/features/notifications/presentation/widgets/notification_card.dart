import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../chats/presentation/widgets/accept_or_reject_first_stage.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notificationModel;
  final Future<void> Function(String id) onDelete;

  const NotificationCard({super.key,
    required this.onDelete,
    required this.notificationModel});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
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
            if(widget.notificationModel.data?['show_accept_reject_buttons'] ?? false)
              AcceptOrRejectFirstStageWidget(onAccept: (ctx)async{}, onReject:  (ctx)async{})
              // Row(
              //   children: [
              //
              //   ],
              // )
          ],
        ),
      ),
    );
  }
}
