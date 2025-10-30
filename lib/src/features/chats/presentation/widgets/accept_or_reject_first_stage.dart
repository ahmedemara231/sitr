import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';

class AcceptOrRejectFirstStageWidget extends StatelessWidget {
  final Future<void> Function(BuildContext context) onAccept;
  final Future<void> Function(BuildContext context) onReject;
  const AcceptOrRejectFirstStageWidget({super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Column(
        spacing: 10.h,
        children: [
          AppText(LocaleKeys.wantToContactWithYou),
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: AppLoadingButton(
                    title: LocaleKeys.accept,
                    asyncCall: (context) => onAccept.call(context)
                ),
              ),
              Expanded(
                child: AppLoadingButton(
                    title: LocaleKeys.refused,
                    buttonColor: Colors.red,
                    asyncCall: (context) => onReject.call(context)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
