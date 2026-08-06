import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/auth/imports.dart'
    show EnterMaleOrFemaleOrChildDataScreen, ScaffoldType;
import '../../../features/auth/presentation/cubits/add_child.dart';
import '../../../features/auth/presentation/cubits/complete_profile_cubit.dart';
import '../../../features/auth/presentation/data/auth_data.dart';
import '../../../features/auth/presentation/widgets/sign_up/sheets/complete_profile_sheet.dart';
import '../../extensions/align_helper.dart';
import '../../helpers/user_type_enum.dart';
import '../../navigation/navigator.dart';
import '../../shared/models/user_models/user_model.dart';
import '../buttons/app_loading_button.dart';
import '../default_bottom_sheet.dart';
import '../icon_widget.dart';

class SuccessSheet extends StatelessWidget {
  final bool isInAuth;
  final Widget? upperText;

  const SuccessSheet({
    super.key,
    required this.isInAuth,
    this.upperText,
  });

  void _manageGender({
    required UserGender gender,
    required UserType type,
  }) {
    if (type.isParent) {
      Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
          scaffoldType: ScaffoldType.centerCard,
          showConditionsAndTerms: true,
          showAlreadyHaveAccount: true,
          onClick: (context, user) => context.read<AddChildCubit>().addChild(
                body: user,
              )));
    } else {
      Go.to(EnterMaleOrFemaleOrChildDataScreen.individual(
        scaffoldType: ScaffoldType.centerCard,
        showConditionsAndTerms: true,
        showAlreadyHaveAccount: true,
        userType: gender,
        onClick: (context, user) =>
            context.read<CompleteProfileCubit>().completeProfile(
                  body: user,
                  onSuccess: (_) => showDefaultBottomSheet(
                      child: const CompleteProfileSheet()),
                ),
      ));
    }
  }

  void _manageNavigation() {
    if (AuthData.unauthorizedUserGender.isUnknown &&
        AuthData.unauthorizedUserType.isUnknown) {
      _manageGender(
          gender: UserModel.currentUser!.gender!.userGender!,
          type: UserModel.currentUser!.type!.userType!);
    } else {
      _manageGender(
          gender: AuthData.unauthorizedUserGender,
          type: AuthData.unauthorizedUserType);
    }
  }

  Future<void> _onButtonTap(BuildContext context) async {
    if (isInAuth) {
      _manageNavigation();
    } else {
      Go.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SuccessIcon().centerWidget,
        if (upperText != null) ...[
          SizedBox(height: 24.h),
          upperText!.centerWidget,
        ],
        SizedBox(height: 32.h),
        AppLoadingButton(
          asyncCall: _onButtonTap,
          title: isInAuth ? LocaleKeys.completeProfile : LocaleKeys.back,
          height: 54.h,
          borderRadius: 100.r,
        ),
      ],
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.r,
      height: 100.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successTint.withValues(alpha: 0.5),
            ),
          ),
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successTint,
            ),
          ),
          IconWidget(
            icon: Icons.check_circle,
            color: AppColors.primary,
            height: 40.sp,
          ),
        ],
      ),
    );
  }
}
