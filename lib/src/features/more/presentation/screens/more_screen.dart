import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/parent_children_screen.dart';
import '../../../chats/presentation/screens/chats_screen.dart';
import '../cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import '../widgets/more_item.dart';
import '../widgets/more_tap_app_bar.dart';
import 'blocked_user_screen/blocked_user_screen.dart';
import 'complaint_and_suggestion/complaints_and_suggestions_screen.dart';
import 'contact_us/contact_us_screen.dart';
import 'my_packages.dart';
import 'profile.dart';
import 'success_partners/success_partners_screen.dart';
import 'terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MorItemModel> moreItemsList = [
      if(UserTypeHelper.isAuthenticated)
        ...[
          MorItemModel(
            icon: Assets.svgUser,
            label: LocaleKeys.profile,
            onTap: () => Go.to(const ProfileScreen()),
          ),
          // MorItemModel(
          //   icon: Assets.svgChatsIcon,
          //   label: LocaleKeys.chats,
          //   onTap: () => Go.to(const ChatsScreen()),
          // ),

          MorItemModel(
            icon: Assets.svgPackageIcon,
            label: LocaleKeys.myPackage,
            onTap: () => Go.to(const MyPackagesScreen()),
          ),
        ],
      if(UserTypeHelper.isAuthenticated && UserModel.isParent)
        MorItemModel(
          icon: Assets.svgMoreChildren,
          label: LocaleKeys.addedChildren,
          onTap: () => Go.to(const ParentChildrenView()),
        ),

      MorItemModel(
        icon: Assets.svgSuccessPartnerIcon,
        label: LocaleKeys.successPartners,
        onTap: () {
          Go.to(const SuccessPartnersScreen());
        },
      ),
      if(UserTypeHelper.isAuthenticated)
        ...[
          MorItemModel(
            icon: Assets.svgBlockUser,
            label: LocaleKeys.blockedCustomers,
            onTap: () {
              Go.to(const BlockedUserScreen());
            },
          ),
          MorItemModel(
            icon: Assets.svgContactUsIcon,
            label: LocaleKeys.contactUs,
            onTap: () {
              Go.to(ContactUsScreen());
            },
          ),
          MorItemModel(
            icon: Assets.svgComplaintIcon,
            label: LocaleKeys.complaintsAndSuggestions,
            onTap: () {
              Go.to(const ComplaintsAndSuggestionsScreen());
            },
          ),
        ],
      MorItemModel(
        icon: Assets.svgAboutIcon,
        label: LocaleKeys.aboutUs,
        onTap: () {
          Go.to(const TermsAndConditionAndAboutUs(
              staticPageType: StaticPageType.about));
        },
      ),
      MorItemModel(
        icon: Assets.svgTermsAndConditionIcon,
        label: LocaleKeys.termsAndConditions,
        onTap: () {
          Go.to(const TermsAndConditionAndAboutUs(
              staticPageType: StaticPageType.terms));
        },
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.whiteGreyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MoreTabAppBar(),
            Column(
              spacing: 10.h,
              children: List.generate(
                  moreItemsList.length,
                      (index) => MoreItem(
                moreItemModel: moreItemsList[index],
              )
              ),
            ).defaultScreenPadding()
          ],
        ),
      ),
    );
  }
}

class MorItemModel {
  final String icon;
  final String label;
  final FutureOr<void> Function()? onTap;
  final bool withSwitch;

  MorItemModel({
    required this.icon,
    required this.label,
    this.onTap,
  }) : withSwitch = false;

  MorItemModel.withSwitch({
    required this.icon,
    required this.label,
  }) : withSwitch = true, onTap = null;
}
