import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';

class ChatCard extends StatelessWidget {
  final String url;
  final String partnerName;
  final String subTitle;
  final String time;
  final int unreadMsgs;

  const ChatCard({super.key,
    required this.url,
    required this.partnerName,
    required this.subTitle,
    required this.time,
    required this.unreadMsgs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 40.sp,
          backgroundImage: NetworkImage(url)
        ),
        title: AppText(partnerName, fontWeight: FontWeight.w500),
        subtitle: AppText(subTitle, color: Colors.grey),
        trailing: Column(
          spacing: 5.h,
          children: [
            if(unreadMsgs > 0)
              Container(
                width: 20.w,
                height: 20.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(child: AppText(unreadMsgs.toString(), color: Colors.white,))
              ),
            AppText(time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
