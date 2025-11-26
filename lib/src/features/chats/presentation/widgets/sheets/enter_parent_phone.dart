import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../auth/presentation/widgets/shared/text_field.dart';

class EnterParentPhoneSheet extends StatefulWidget {
  final FutureOr<void> Function(BuildContext context, String phone) onSubmit;
  const EnterParentPhoneSheet({super.key,
    required this.onSubmit,
  });

  @override
  State<EnterParentPhoneSheet> createState() => _EnterParentPhoneSheetState();
}

class _EnterParentPhoneSheetState extends State<EnterParentPhoneSheet> {
  late final TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.small(
        asyncCall: (context) => widget.onSubmit.call(context, controller.text),
        btnTitle: LocaleKeys.confirm,
        upperWidget: Column(
          spacing: 10.h,
          children: [
            AppText(LocaleKeys.pleaseEnterParentPhoneNumber),
            AppText(LocaleKeys.enterTheFollowingOptionExternalCommunicationWillBeEstablished),

            SignUpTextField(
                upperTitle: LocaleKeys.phoneNumber,
                title: LocaleKeys.pleaseEnterParentPhoneNumber,
                inputType: TextInputType.phone,
                controller: controller
            )
          ],
        )
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }
}
