import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/align_helper.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/loading_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../auth/imports.dart';
import '../cubit/logout_cubit.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<LogoutCubit>().logout(
      onSuccess: (msg) async {
        await UserCubit.instance.logout();
        Go.back(); // Close the bottom sheet first
        MessageUtils.show(
          msg,
          state: MsgState.success,
        );
        Go.offAll(const LoginScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LogoutIcon().centerWidget,
        SizedBox(height: 20.h),
        AppText(
          LocaleKeys.logout,
          fontSize: 19.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
          textAlign: TextAlign.center,
        ).centerWidget,
        SizedBox(height: 8.h),
        AppText(
          LocaleKeys.areYouSureToLogout,
          fontSize: 14.sp,
          color: AppColors.darkGay,
          height: 1.7,
          textAlign: TextAlign.center,
        ).centerWidget,
        SizedBox(height: 28.h),
        AppLoadingButton(
          asyncCall: (context) async {
            Go.back();
          },
          title: LocaleKeys.cancel,
          height: 52.h,
          borderRadius: 50.r,
          fontSize: 16.sp,
        ),
        SizedBox(height: 11.h),
        LoadingButton(
          call: (context) async => await _logout(context),
          btnColor: AppColors.white,
          borderColor: AppColors.error,
          borderRadius: 50.r,
          height: 52.h,
          loadingWidget: const CircularProgressIndicator(
            color: AppColors.error,
          ).paddingAll(3.r),
          idleWidget: FittedBox(
            child: AppText(
              LocaleKeys.logout,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoutIcon extends StatelessWidget {
  const _LogoutIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92.r,
      height: 92.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 92.r,
            height: 92.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandFaint.withValues(alpha: 0.4),
            ),
          ),
          Container(
            width: 72.r,
            height: 72.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandLight,
            ),
          ),
          IconWidget(
            icon: Assets.svgLogOutIcon,
            color: AppColors.primary,
            width: 28.sp,
            height: 28.sp,
          ),
        ],
      ),
    );
  }
}
