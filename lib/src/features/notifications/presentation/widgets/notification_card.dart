import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;
  final Future<void> Function(String id) onDelete;

  const NotificationCard({
    super.key,
    required this.onDelete,
    required this.notificationModel,
  });

  // Design tokens mapped from the React/Tailwind card.
  static const Color _amber50 = Color(0xFFFFFBEB); // bg-amber-50
  static const Color _amber200 = Color(0xFFFDE68A); // border-amber-200
  static const Color _gray900 = Color(0xFF111827); // title
  static const Color _gray700 = Color(0xFF374151); // subtitle
  static const Color _gray400 = Color(0xFF9CA3AF); // time
  static const Color _gray100 = Color(0xFFF3F4F6); // card border
  static const Color _gray50 = Color(0xFFF9FAFB); // bottom divider
  static const Color _red500 = Color(0xFFEF4444); // delete icon

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          notificationModel.type.getType.navigation
              .navigate(data: notificationModel.data!);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: _gray100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
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
                          notificationModel.title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: _gray900,
                          height: 1.3,
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          notificationModel.body,
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
                          onTap: () async =>
                              onDelete.call(notificationModel.id),
                          child: SvgPic(
                            assetName: Assets.svgTrashIcon,
                            color: _red500,
                            size: 18.sp,
                          ),
                        ),
                        AppText(
                          notificationModel.createdAt,
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
