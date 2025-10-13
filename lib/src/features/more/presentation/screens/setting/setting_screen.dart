import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../widgets/more_item.dart';
import '../more_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

List<MorItemModel> moreItemsList = [
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
    onSwitch: () {
      // Go.to(const SuccessPartnersScreen());
    },
  ),

  MorItemModel(
    icon: Assets.svgTrashIcon,
    label: LocaleKeys.deleteAccount,
    onTap: () {
      // Go.to(const BlockedUserScreen());
    },
  ),
];
