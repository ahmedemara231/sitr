import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';

class AcceptOrRejectFirstStageWidget extends StatelessWidget {
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;
  const AcceptOrRejectFirstStageWidget({super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Column(
        children: [
          AppText(LocaleKeys.wantToContactWithYou),
          Row(
            children: [
              AppDefaultButton.withBackGroundColor(
                  title: LocaleKeys.accept,
                  onTap: () => onAccept.call()
              ),
              AppDefaultButton.withBackGroundColor(
                  title: LocaleKeys.refused,
                  onTap: () => onReject.call()
              ),
            ],
          )
        ],
      ),
    );
  }
}
