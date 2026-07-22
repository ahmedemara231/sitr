import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../cubit/delete_account.dart';

class DeleteAccountReasonSheet extends StatelessWidget {
  final FutureOr<void> Function(String msg) onSuccess;

  const DeleteAccountReasonSheet({
    super.key,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => DeleteAccountReasonsCubit()..getReasons()),
        BlocProvider(create: (context) => DeleteAccountCubit()),
      ],
      child: _DeleteAccountReasonSheetBody(onSuccess: onSuccess),
    );
  }
}

class _DeleteAccountReasonSheetBody extends StatefulWidget {
  final FutureOr<void> Function(String msg) onSuccess;

  const _DeleteAccountReasonSheetBody({
    required this.onSuccess,
  });

  @override
  State<_DeleteAccountReasonSheetBody> createState() =>
      _DeleteAccountReasonSheetBodyState();
}

class _DeleteAccountReasonSheetBodyState
    extends State<_DeleteAccountReasonSheetBody>
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
          onUnsafe: (reason) => MessageUtils.showSnackBar(
            _unsafeReasonMessage(reason),
          ),
        );
  }

  String _unsafeReasonMessage(String reason) {
    switch (reason) {
      case 'has_balance':
        return LocaleKeys.cannotDeleteAccountWithBalance;
      case 'has_live_chat':
        return LocaleKeys.cannotDeleteAccountWithLiveChat;
      default:
        return reason;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: .86.sh),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom + 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WarningIcon(animation: _pulseController),
              18.szH,
              AppText(
                LocaleKeys.whyAreYouDeletingYourAccount,
                textAlign: TextAlign.center,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.deleteAccountReasonText,
                height: 1.45,
              ).paddingSymmetric(horizontal: 20.w),
              8.szH,
              AppText(
                LocaleKeys.chooseDeleteAccountReasonHint,
                textAlign: TextAlign.center,
                fontSize: 13.sp,
                color: AppColors.deleteAccountReasonMuted,
                height: 1.65,
              ).paddingSymmetric(horizontal: 24.w),
              20.szH,
              BlocBuilder<DeleteAccountReasonsCubit,
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
                              isCustomReason ? _customReason : reasons[index];
                          return _ReasonCard(
                            reason: reason,
                            icon: _iconForIndex(index, reason),
                            selected: _selectedReason?.id == reason.id,
                            onTap: () => _selectReason(reason),
                          );
                        },
                      ),
                      if (_isCustomReasonSelected)
                        DefaultTextField(
                          controller: _reasonController,
                          title: LocaleKeys.writeReasonHere,
                          inputType: TextInputType.multiline,
                          minLines: 2,
                          maxLines: 3,
                          maxLength: 500,
                          borderRadius: 14.r,
                          borderColor: AppColors.deleteAccountReasonBorder,
                          fillColor:
                              AppColors.deleteAccountReasonCardBackground,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          style: TextStyle(
                            color: AppColors.deleteAccountReasonText,
                            fontSize: 13.sp,
                            height: 1.6,
                          ),
                          onChanged: (_) => setState(() {}),
                        )
                    ],
                  ),
                ),
              ).paddingSymmetric(horizontal: 2.w),
              18.szH,
              BlocBuilder<DeleteAccountCubit, AsyncState<dynamic>>(
                builder: (context, state) {
                  return Column(
                    children: [
                      AppLoadingButton(
                        height: 48.h,
                        width: double.infinity,
                        borderRadius: 16.r,
                        buttonColor: _canDelete
                            ? AppColors.primary
                            : AppColors.deleteAccountReasonDisabledBackground,
                        textColor: _canDelete
                            ? AppColors.white
                            : AppColors.deleteAccountReasonDisabledText,
                        title: LocaleKeys.continueToDeleteAccount,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        enabled: _canDelete,
                        asyncCall: _deleteAccount,
                      ),
                      10.szH,
                      AppLoadingButton(
                        height: 48.h,
                        width: double.infinity,
                        borderRadius: 16.r,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.deleteAccountReasonBorder,
                        textColor: AppColors.deleteAccountReasonMuted,
                        title: LocaleKeys.back,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        enabled: !state.isLoading,
                        asyncCall: (context) async => Go.back(),
                      ),
                    ],
                  );
                },
              ),
              14.szH,
              AppText.withIcon(
                icon: Icon(
                  Icons.info_outline,
                  size: 12.r,
                  color: AppColors.deleteAccountReasonSubtle,
                ),
                text: LocaleKeys.irreversibleDeleteAccountWarning,
                color: AppColors.deleteAccountReasonSubtle,
                fontSize: 11.5.sp,
                textAlign: TextAlign.center,
                height: 1.4,
              ),
            ],
          ),
        ),
      ),
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }

  IconData _iconForIndex(int index, DeleteAccountReason reason) {
    if (reason.isOther) return Icons.edit_outlined;

    const icons = [
      Icons.access_time_rounded,
      Icons.bug_report_outlined,
      Icons.shield_outlined,
      Icons.compare_arrows_rounded,
      Icons.edit_outlined,
    ];
    return icons[index % icons.length];
  }
}

class _WarningIcon extends StatelessWidget {
  final Animation<double> animation;

  const _WarningIcon({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 72.r,
          height: 72.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary
                .withValues(alpha: .08 + animation.value * .06),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: .28), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: .12 + animation.value * .16),
                blurRadius: 16 + animation.value * 16,
                spreadRadius: animation.value * 2,
              ),
            ],
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 32.r,
            color: AppColors.primary,
          ),
        );
      },
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final DeleteAccountReason reason;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonCard({
    required this.reason,
    required this.icon,
    required this.selected,
    required this.onTap,
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
            _ReasonIconBox(icon: icon),
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
            _ReasonRadio(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _ReasonIconBox extends StatelessWidget {
  final IconData icon;

  const _ReasonIconBox({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: .18)),
      ),
      child: Icon(icon, size: 19.r, color: AppColors.primary),
    );
  }
}

class _ReasonRadio extends StatelessWidget {
  final bool selected;

  const _ReasonRadio({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? AppColors.primary.withValues(alpha: .08)
            : AppColors.transparent,
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.deleteAccountReasonRadioBorder,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: selected ? 10.r : 0,
          height: selected ? 10.r : 0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
