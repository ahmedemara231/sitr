import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import 'chat_access_requirement_sheet.dart';

class CompleteProfileRequiredSheet extends StatelessWidget {
  final Future<void> Function() onCompleteProfilePressed;

  const CompleteProfileRequiredSheet({
    required this.onCompleteProfilePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatAccessRequirementSheet(
      illustration: const _IncompleteProfileIllustration(),
      title: LocaleKeys.completeProfileRequiredTitle,
      description: LocaleKeys.completeProfileRequiredDescription,
      actionTitle: LocaleKeys.completeProfile,
      onActionPressed: onCompleteProfilePressed,
    );
  }
}

class _IncompleteProfileIllustration extends StatelessWidget {
  const _IncompleteProfileIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100.r,
      child: Assets.assets.lottie.data.incompleteProfile.lottie(
        repeat: true,
        fit: BoxFit.contain,
      ),
    );
  }
}
