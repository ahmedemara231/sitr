import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/default_button.dart';
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
  static const Color _border = Color(0xFFE2DDD6);
  static const Color _text = Color(0xFF1A1208);
  static const Color _muted = Color(0xFF666666);
  static const Color _subtle = Color(0xFF9E9590);
  static const Color _cardBackground = Color(0xFFFDFCFB);
  static const Color _disabledBackground = Color(0xFFEDE8E2);

  DeleteAccountReason? _selectedReason;
  late final TextEditingController _reasonController;
  late final AnimationController _pulseController;

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
    setState(() => _selectedReason = reason);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final reason = _selectedReason;
    if (reason == null) return;

    await context.read<DeleteAccountCubit>().deleteAccount(
          reason: reason,
          customReason: reason.isOther ? _reasonController.text : null,
          onSuccess: (msg) => widget.onSuccess(msg),
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
                color: _text,
                height: 1.45,
              ).paddingSymmetric(horizontal: 20.w),
              8.szH,
              AppText(
                LocaleKeys.chooseDeleteAccountReasonHint,
                textAlign: TextAlign.center,
                fontSize: 13.sp,
                color: _muted,
                height: 1.65,
              ).paddingSymmetric(horizontal: 24.w),
              20.szH,
              BlocBuilder<DeleteAccountReasonsCubit,
                  AsyncState<List<DeleteAccountReason>>>(
                builder: (context, state) {
                  if (state.isLoading && state.data.isEmpty) {
                    return const _ReasonsLoading();
                  }

                  if (state.isError && state.data.isEmpty) {
                    return _ReasonsError(
                      onRetry: () => context
                          .read<DeleteAccountReasonsCubit>()
                          .getReasons(),
                    );
                  }

                  if (state.data.isEmpty) {
                    return const _ReasonsEmpty();
                  }

                  return Column(
                    children: [
                      ...List.generate(
                        state.data.length,
                        (index) {
                          final reason = state.data[index];
                          return _ReasonCard(
                            reason: reason,
                            icon: _iconForIndex(index, reason),
                            selected: _selectedReason?.id == reason.id,
                            onTap: () => _selectReason(reason),
                          ).paddingOnly(
                              bottom:
                                  index == state.data.length - 1 ? 0 : 10.h);
                        },
                      ),
                      if (_selectedReason?.isOther == true)
                        DefaultTextField(
                          controller: _reasonController,
                          title: LocaleKeys.writeReasonHere,
                          inputType: TextInputType.multiline,
                          minLines: 2,
                          maxLines: 3,
                          borderRadius: 14.r,
                          borderColor: _border,
                          fillColor: _cardBackground,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          style: TextStyle(
                            color: _text,
                            fontSize: 13.sp,
                            height: 1.6,
                          ),
                        ).paddingOnly(top: 10.h),
                    ],
                  );
                },
              ).paddingSymmetric(horizontal: 2.w),
              18.szH,
              BlocBuilder<DeleteAccountCubit, AsyncState<dynamic>>(
                builder: (context, state) {
                  final bool canDelete =
                      _selectedReason != null && !state.isLoading;
                  return Column(
                    children: [
                      DefaultButton(
                        height: 48.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16.r),
                        color:
                            canDelete ? AppColors.primary : _disabledBackground,
                        onTap: canDelete ? () => _deleteAccount(context) : null,
                        customChild: state.isLoading
                            ? SizedBox.square(
                                dimension: 20.r,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : AppText(
                                LocaleKeys.continueToDeleteAccount,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: canDelete
                                    ? Colors.white
                                    : const Color(0xFFB0A89E),
                              ),
                      ),
                      10.szH,
                      DefaultButton(
                        height: 48.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                        borderColor: _border,
                        textColor: _muted,
                        title: LocaleKeys.back,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        onTap: state.isLoading ? null : () => Go.back(),
                      ),
                    ],
                  );
                },
              ),
              14.szH,
              AppText.withIcon(
                icon: Icon(Icons.info_outline, size: 12.r, color: _subtle),
                text: LocaleKeys.irreversibleDeleteAccountWarning,
                color: _subtle,
                fontSize: 11.5.sp,
                textAlign: TextAlign.center,
                height: 1.4,
              ),
            ],
          ),
        ),
      ),
    );
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
              : _DeleteAccountReasonSheetBodyState._cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : _DeleteAccountReasonSheetBodyState._border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withValues(alpha: .10)
                  : Colors.black.withValues(alpha: .04),
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
                        ? _DeleteAccountReasonSheetBodyState._text
                        : const Color(0xFF2E2416),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (reason.description?.isNotEmpty == true) ...[
                    3.szH,
                    AppText(
                      reason.description!,
                      fontSize: 11.5.sp,
                      color: _DeleteAccountReasonSheetBodyState._muted,
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
            : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFFC8C0B6),
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

class _ReasonsLoading extends StatelessWidget {
  const _ReasonsLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _ReasonsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _ReasonsError({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          LocaleKeys.unableToLoadDeleteAccountReasons,
          color: _DeleteAccountReasonSheetBodyState._muted,
          fontSize: 13.sp,
          textAlign: TextAlign.center,
        ),
        12.szH,
        DefaultButton(
          height: 40.h,
          width: 150.w,
          borderRadius: BorderRadius.circular(12.r),
          title: LocaleKeys.tryAgain,
          fontSize: 13.sp,
          onTap: onRetry,
        ),
      ],
    ).paddingSymmetric(vertical: 20.h);
  }
}

class _ReasonsEmpty extends StatelessWidget {
  const _ReasonsEmpty();

  @override
  Widget build(BuildContext context) {
    return AppText(
      LocaleKeys.noDeleteAccountReasonsFound,
      color: _DeleteAccountReasonSheetBodyState._muted,
      fontSize: 13.sp,
      textAlign: TextAlign.center,
    ).paddingSymmetric(vertical: 30.h);
  }
}
