import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagify/widgets/text.dart';

import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/res/config_imports.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notificationModel;

  const NotificationCard({super.key, required this.notificationModel});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.notificationModel.type.getType.navigation
            .navigate(data: widget.notificationModel.data.toJson());
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(Assets.svgNotificationIcon),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(widget.notificationModel.title),
                  SizedBox(height: 7.h),
                  AppText(widget.notificationModel.body, fontSize: 10.sp),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                AppText(widget.notificationModel.createdAt, fontSize: 10.sp, color: Colors.grey),
                IconButton(
                    onPressed: () async {},
                  icon: const Icon(Icons.delete),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
