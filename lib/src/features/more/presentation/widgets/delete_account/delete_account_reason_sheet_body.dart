import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/custom_messages.dart';
import '../../cubit/delete_account.dart';
import '../../models/delete_account_reason.dart';
import '../../models/delete_account_safety.dart';
import 'delete_account_reason_actions.dart';
import 'delete_account_reason_footer.dart';
import 'delete_account_reason_header.dart';
import 'delete_account_reasons_list.dart';

class DeleteAccountReasonSheetBody extends StatefulWidget {
  final FutureOr<void> Function(String msg) onSuccess;

  const DeleteAccountReasonSheetBody({
    required this.onSuccess,
    super.key,
  });

  @override
  State<DeleteAccountReasonSheetBody> createState() =>
      _DeleteAccountReasonSheetBodyState();
}

class _DeleteAccountReasonSheetBodyState
    extends State<DeleteAccountReasonSheetBody>
    with SingleTickerProviderStateMixin {
  DeleteAccountReason? _selectedReason;
  late final TextEditingController _reasonController;
  late final AnimationController _pulseController;

  bool get _isCustomReasonSelected => _selectedReason?.isOther == true;

  bool get _canDelete {
    if (_selectedReason == null) return false;
    if (!_isCustomReasonSelected) return true;
    return _reasonController.text.trim().isNotEmpty;
  }

  DeleteAccountReason get _customReason => DeleteAccountReason(
        id: -1,
        title: LocaleKeys.writeReasonHere,
        isOther: true,
      );

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
      lowerBound: 0,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _selectReason(DeleteAccountReason reason) {
    if (!reason.isOther) {
      _reasonController.clear();
    }
    setState(() => _selectedReason = reason);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final DeleteAccountReason? reason = _selectedReason;
    if (reason == null || !_canDelete) return;

    await context.read<DeleteAccountCubit>().checkSafetyAndDeleteAccount(
          reason: reason.isOther ? null : reason,
          customReason: reason.isOther ? _reasonController.text : null,
          onSuccess: (msg) => widget.onSuccess(msg),
          onUnsafe: (reason) => MessageUtils.showTopMsg(
            DeleteAccountUnsafeReason.fromValue(reason).message,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: .86.sh),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom + 8.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DeleteAccountReasonHeader(animation: _pulseController),
              DeleteAccountReasonsList(
                selectedReason: _selectedReason,
                customReason: _customReason,
                reasonController: _reasonController,
                isCustomReasonSelected: _isCustomReasonSelected,
                onReasonSelected: _selectReason,
                onCustomReasonChanged: (_) => setState(() {}),
              ),
              DeleteAccountReasonActions(
                canDelete: _canDelete,
                onDeletePressed: _deleteAccount,
              ),
              const DeleteAccountReasonFooter(),
            ],
          ),
        ),
      ),
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }
}
