import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../models/delete_account_reason.dart';
import 'delete_account_reason_icon.dart';
import 'delete_account_reason_radio.dart';

class DeleteAccountReasonCard extends StatelessWidget {
  final DeleteAccountReason reason;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const DeleteAccountReasonCard({
    required this.reason,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: .05)
              : AppColors.deleteAccountReasonCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.deleteAccountReasonBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withValues(alpha: .10)
                  : AppColors.blackShadow.withValues(alpha: .04),
              blurRadius: selected ? 16 : 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            DeleteAccountReasonIcon(icon: icon),
            11.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    reason.title,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.deleteAccountReasonText
                        : AppColors.deleteAccountReasonTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (reason.description?.isNotEmpty == true) ...[
                    3.szH,
                    AppText(
                      reason.description!,
                      fontSize: 11.5.sp,
                      color: AppColors.deleteAccountReasonMuted,
                      height: 1.4,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            11.szW,
            DeleteAccountReasonRadio(selected: selected),
          ],
        ),
      ),
    );
  }
}
