import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../auth/imports.dart';
import '../../cubit/delete_account.dart';
import '../../widgets/more_item.dart';
import '../more_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MorItemModel> moreItemsList = [
      MorItemModel(
        icon: Assets.svgUser,
        label: LocaleKeys.profile,
        // onTap: () => Go.to(),
      ),
      MorItemModel(
        icon: Assets.svgContactPhone,
        label: LocaleKeys.changePhoneNumber,
        // onTap: () => Go.to(const MyPackagesScreen()),
      ),

      MorItemModel.withSwitch(
        icon: Assets.svgNotificationIcon,
        label: LocaleKeys.notifications,
      ),

      MorItemModel(
        icon: Assets.svgTrashIcon,
        label: LocaleKeys.deleteAccount,
        onTap: (){
          showDefaultBottomSheet(
              child: BlocProvider(
                create: (context) => DeleteAccountCubit(),
                child: AppBottomSheet.large(
                    cancelBackgroundColor: AppColors.cancelColor,
                    asyncCall: (context) => context.read<DeleteAccountCubit>().deleteAccount(
                        onSuccess: () {
                          Go.offAll(const LoginScreen());
                          UserCubit.instance.logout();
                        }
                    ),
                    btnTitle: LocaleKeys.confirm,
                    upperWidget: Column(
                      children: [
                        SizedBox.square(
                            dimension: 200.sp,
                            child: Image.asset(Assets.imagesDeleteIcon)
                        ),
                        AppText(LocaleKeys.areYouSureYouWantToDeleteYourAccount, fontWeight: FontWeight.w500),
                      ],
                    )
                ),
              )
          );
        },
      ),
    ];
    return AppScaffold(
      scaffoldBackgroundColor: AppColors.whiteGreyColorProMax,
        appBarTitle: LocaleKeys.settings,
        body: Column(
          spacing: 10.h,
          children: List.generate(
              moreItemsList.length,
                  (index) => MoreItem(
                moreItemModel: moreItemsList[index],
              )
          ),
        )
    );
  }
}
