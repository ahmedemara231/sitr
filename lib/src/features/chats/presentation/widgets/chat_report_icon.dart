import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/sheets/report_sheet.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../data/chat_sheet_manager.dart';

class ChatReportIcon extends StatelessWidget {
  final int id;
  const ChatReportIcon({super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => ChatSheetManager.show(
          child: ReportSheet(
            id: id,
          ),
        ),
        child: FittedBox(
          child: Row(
            spacing: 5.w,
            children: [
              SizedBox.square(
                dimension: 20.w,
                  child: SvgPic(assetName: Assets.assets.svg.report.path, color: Colors.red,)
              ),
              AppText(LocaleKeys.report, fontSize: 10.sp, fontWeight: FontWeight.bold)
            ],
          ),
        ).paddingBottom(10.h),
    );
  }
}
