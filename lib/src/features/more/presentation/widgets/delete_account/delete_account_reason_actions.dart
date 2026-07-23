import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../cubit/delete_account.dart';

class DeleteAccountReasonActions extends StatelessWidget {
  final bool canDelete;
  final Future<void> Function(BuildContext context) onDeletePressed;

  const DeleteAccountReasonActions({
    required this.canDelete,
    required this.onDeletePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountCubit, AsyncState<dynamic>>(
      builder: (context, state) => Column(
        children: [
          18.szH,
          AppLoadingButton(
            height: 48.h,
            width: double.infinity,
            borderRadius: 16.r,
            buttonColor: canDelete
                ? AppColors.primary
                : AppColors.deleteAccountReasonDisabledBackground,
            textColor: canDelete
                ? AppColors.white
                : AppColors.deleteAccountReasonDisabledText,
            title: LocaleKeys.continueToDeleteAccount,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            enabled: canDelete,
            asyncCall: onDeletePressed,
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
      ),
    );
  }
}
