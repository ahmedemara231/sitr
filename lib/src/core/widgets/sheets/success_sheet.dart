import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/auth/imports.dart' show EnterMaleOrFemaleOrChildDataScreen, ScaffoldType;
import '../../../features/auth/presentation/cubits/add_child.dart';
import '../../../features/auth/presentation/cubits/complete_profile_cubit.dart';
import '../../../features/auth/presentation/data/auth_data.dart';
import '../../../features/auth/presentation/widgets/sign_up/sheets/add_child_sheet.dart';
import '../../../features/auth/presentation/widgets/sign_up/sheets/complete_profile_sheet.dart';
import '../../helpers/user_type_enum.dart';
import '../../navigation/navigator.dart';
import '../../shared/models/user_models/user_model.dart';
import '../app_bottom_sheet.dart';
import '../default_bottom_sheet.dart';

class SuccessSheet extends StatelessWidget {
  final bool isInAuth;
  final Widget? upperText;
  const SuccessSheet({super.key,
    required this.isInAuth,
    this.upperText
  });

  void _manageGender({
    required UserGender gender,
    required UserType type,
}){
    if(type.isParent){
      Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
          scaffoldType: ScaffoldType.centerCard,
          showConditionsAndTerms: true,
          showAlreadyHaveAccount: true,
          onClick: (context, user) => context.read<AddChildCubit>().addChild(
            body: user,
            onSuccess: () {
              AuthData.childrenNumber.value.increment(user.gender!.userGender!);
              showDefaultBottomSheet(
                  child: const AddChildSheet()
              );
            },
          )
      ));

    }else{
      Go.to(EnterMaleOrFemaleOrChildDataScreen.individual(
        scaffoldType: ScaffoldType.centerCard,
        showConditionsAndTerms: true,
        showAlreadyHaveAccount: true,
        userType: gender,
        onClick: (context, user) => context.read<CompleteProfileCubit>().completeProfile(
          body: user, onSuccess: () => showDefaultBottomSheet(child: const CompleteProfileSheet()),
        ),
      ));
    }
  }

  void _manageNavigation(){
    if(AuthData.unauthorizedUserGender.isUnknown &&
        AuthData.unauthorizedUserType.isUnknown){
      _manageGender(
          gender: UserModel.currentUser!.gender!.userGender!,
          type: UserModel.currentUser!.type!.userType!
      );


    }else{
      _manageGender(
          gender: AuthData.unauthorizedUserGender,
          type: AuthData.unauthorizedUserType
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppBottomSheet.small(
            asyncCall: (context) => !isInAuth?
            Go.back() : _manageNavigation(),
            btnTitle: isInAuth? LocaleKeys.completeProfile : LocaleKeys.back,
            upperWidget: Column(
              children: [
                Lottie.asset(Assets.successDone),
                upperText ?? const SizedBox.shrink(),
              ],
            )
        )
      ],
    );
  }
}
