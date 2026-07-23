import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/delete_account.dart';
import '../../models/delete_account_reason.dart';
import 'delete_account_reason_card.dart';

class DeleteAccountReasonsList extends StatelessWidget {
  final DeleteAccountReason? selectedReason;
  final DeleteAccountReason customReason;
  final TextEditingController reasonController;
  final bool isCustomReasonSelected;
  final void Function(DeleteAccountReason reason) onReasonSelected;
  final void Function(String? value) onCustomReasonChanged;

  const DeleteAccountReasonsList({
    required this.selectedReason,
    required this.customReason,
    required this.reasonController,
    required this.isCustomReasonSelected,
    required this.onReasonSelected,
    required this.onCustomReasonChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountReasonsCubit,
        AsyncState<List<DeleteAccountReason>>>(
      builder: (context, state) => StatusBuilder(
        data: state,
        onSuccess: (reasons, context) => Column(
          spacing: 10.h,
          children: [
            ...List.generate(
              reasons.length + 1,
              (index) {
                final bool isCustomReason = index == reasons.length;
                final DeleteAccountReason reason =
                    isCustomReason ? customReason : reasons[index];
                return DeleteAccountReasonCard(
                  reason: reason,
                  icon: _iconForIndex(index, reason),
                  selected: selectedReason?.id == reason.id,
                  onTap: () => onReasonSelected(reason),
                );
              },
            ),
            if (isCustomReasonSelected)
              DefaultTextField(
                controller: reasonController,
                title: LocaleKeys.writeReasonHere,
                inputType: TextInputType.multiline,
                minLines: 2,
                maxLines: 3,
                maxLength: 500,
                borderRadius: 14.r,
                borderColor: AppColors.deleteAccountReasonBorder,
                fillColor: AppColors.deleteAccountReasonCardBackground,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                style: TextStyle(
                  color: AppColors.deleteAccountReasonText,
                  fontSize: 13.sp,
                  height: 1.6,
                ),
                onChanged: onCustomReasonChanged,
              ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: 2.w);
  }

  IconData _iconForIndex(int index, DeleteAccountReason reason) {
    if (reason.isOther) return Icons.edit_outlined;

    const List<IconData> icons = [
      Icons.access_time_rounded,
      Icons.bug_report_outlined,
      Icons.shield_outlined,
      Icons.compare_arrows_rounded,
      Icons.edit_outlined,
    ];
    return icons[index % icons.length];
  }
}
