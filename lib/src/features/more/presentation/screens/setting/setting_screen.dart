import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../chats/data/chat_sheet_manager.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_messages.dart';
import '../../../../../core/widgets/lang_icon.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../../core/widgets/sheets/delete_sheet.dart';
import '../../../../auth/imports.dart';
import '../../cubit/edit_profile.dart';
import '../../../../otp/presentation/otp.dart';
import '../../cubit/change_phone_manager.dart';
import '../../cubit/delete_account.dart';
import '../../widgets/more_item.dart';
import '../../widgets/change_phone_sheet_body.dart';
import '../edit_parent_profile_screen.dart';
import '../more_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static void _openProfileEdit() {
    UserModel.isIndividual
        ? Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
            scaffoldType: ScaffoldType.appScaffold,
            userType: UserModel.currentUser?.gender?.userGender,
            showGenderSelection: false,
            initialValue: UserModel.currentUser as IndividualUserModel,
            onClick: (context, user) => context.read<EditProfileCubit>().editProfile(
                  body: user,
                  onSuccess: (data) {
                    UserCubit.instance.updateUser(data.data);
                    MessageUtils.showSnackBar(data.msg);
                    Go.back();
                  },
                ),
          ))
        : Go.to(const EditParentProfileScreen());
  }

  static void _openChangePhone() {
    Go.to(
      BlocProvider(
        create: (context) => ChangePhoneManagerCubit(),
        child: OtpScreen(
          upperWidget: Column(
            children: [
              AppText(
                LocaleKeys.changePhoneNumber,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              12.szH,
            ],
          ),
          phone: UserCubit.instance.user.phone ?? '',
          title: LocaleKeys.changePhoneNumber,
          onEnterScreen: (context) => context.read<ChangePhoneManagerCubit>().manage(
                phase: Phase.sendOld,
                phone: UserCubit.instance.user.phone ?? '',
              ),
          onConfirmCode: (context, code) => context.read<ChangePhoneManagerCubit>().manage(
                phase: Phase.checkOld,
                code: code,
                onSuccess: (data) => ChatSheetManager.show(
                  child: const ChangePhoneSheetBody(),
                ),
              ),
        ),
      ),
    );
  }

  static void _openDeleteAccount() {
    ChatSheetManager.show(
      child: BlocProvider(
        create: (context) => DeleteAccountCubit(),
        child: DeleteSheet(
          asyncCall: (context) => context.read<DeleteAccountCubit>().deleteAccount(
                onSuccess: (msg) async {
                  await UserCubit.instance.logout();
                  Go.back();
                  MessageUtils.showSnackBar(msg);
                  Go.offAll(const LoginScreen());
                },
              ),
          title: LocaleKeys.areYouSureYouWantToDeleteYourAccount,
          secondTitle: LocaleKeys.ifDeletedAllDataWillBeDeleted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final List<MorItemModel> moreItemsList = [
      MorItemModel(
        icon: Assets.svgUser,
        label: LocaleKeys.editProfile,
        onTap: () => _openProfileEdit(),
      ),
      MorItemModel(
        icon: Assets.svgSettingPhone,
        label: LocaleKeys.changePhoneNumber,
        onTap: _openChangePhone,
      ),
      MorItemModel(
        icon: Assets.svgLangIcon,
        label: LocaleKeys.changeLanguage,
        onTap: () => ChatSheetManager.show(child: const LangSheet(withRequest: true)),
      ),
      MorItemModel.withSwitch(
        icon: Assets.svgNotificationIcon,
        label: LocaleKeys.notifications,
      ),
      MorItemModel(
        icon: Assets.svgTrashIcon,
        label: LocaleKeys.deleteAccount,
        onTap: _openDeleteAccount,
      ),
    ];

    return AppScaffold(
      scaffoldBackgroundColor: AppColors.whiteGreyColorProMax,
      appBarTitle: LocaleKeys.settings,
      body: Column(
        spacing: 10.h,
        children: List.generate(
          moreItemsList.length,
          (index) => MoreItem(moreItemModel: moreItemsList[index]),
        ),
      ),
    );
  }
}
