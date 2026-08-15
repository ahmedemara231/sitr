import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../extensions/sized_box_helper.dart';
import '../../../../navigation/navigator.dart';
import '../../../app_text.dart';
import 'profile_header_button.dart';

class ProfileTopBar extends StatelessWidget {
  final void Function()? onReportPressed;
  final void Function()? onBlockPressed;

  const ProfileTopBar({
    super.key,
    required this.onReportPressed,
    required this.onBlockPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = ModalRoute.of(context)?.canPop ?? false;
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppText(
            LocaleKeys.profile,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          if (canPop)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ProfileHeaderButton(
                semanticLabel: LocaleKeys.back,
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: Go.back,
              ),
            ),
          if (onReportPressed != null || onBlockPressed != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onReportPressed != null)
                    ProfileHeaderButton(
                      semanticLabel: LocaleKeys.report,
                      icon: Icons.flag_outlined,
                      onPressed: onReportPressed!,
                    ),
                  if (onReportPressed != null && onBlockPressed != null) 8.szW,
                  if (onBlockPressed != null)
                    ProfileHeaderButton(
                      semanticLabel: LocaleKeys.blockedCustomers,
                      icon: Assets.assets.svg.blockUser.path,
                      onPressed: onBlockPressed!,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
