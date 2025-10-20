import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';

class ChatCard extends StatelessWidget {
  final String url;
  final String partnerName;
  final String subTitle;

  const ChatCard({super.key,
    required this.url,
    required this.partnerName,
    required this.subTitle,
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
      ),
    );
  }
}
