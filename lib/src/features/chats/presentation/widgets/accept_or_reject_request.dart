import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';

class AcceptOrRejectRequestWidget extends StatelessWidget {
  final String requestName;
  final Future<void> Function(BuildContext context) onAccept;
  final Future<void> Function(BuildContext context) onReject;
  const AcceptOrRejectRequestWidget({super.key,
    required this.requestName,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        // AppText()
        AppText(LocaleKeys.partnerWantsTo+requestName),
        AppLoadingButton(asyncCall: onAccept, title: LocaleKeys.accept),
        AppLoadingButton(asyncCall: onReject, title: LocaleKeys.refused),
      ],
    );
  }
}
