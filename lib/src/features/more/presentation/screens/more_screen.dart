import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/assets.gen.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import '../widgets/custom_icon_inside_container.dart';
import '../widgets/more_item.dart';
import '../widgets/more_tap_app_bar.dart';
import 'blocked_user_screen/blocked_user_screen.dart';
import 'complaint_and_suggestion/complaints_and_suggestions_screen.dart';
import 'contact_us/contact_us_screen.dart';
import 'success_partners/success_partners_screen.dart';
import 'terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  initState() {

    //  remove this line when integrate auth
    injector<NetworkService>()
        .setToken('Bearer 138|iKDgQ2TE1R0m4DQIOkD6NtMd6LFVnMv9Q3aS0NCk');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteGreyColor,
      body: Column(
        children: [
          const MoreTabAppBar(),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => MoreItem(
                  moreItemModel: moreItemsList[index],
                ),
                separatorBuilder: (context, index) => 10.szH,
                itemCount: moreItemsList.length
            ).defaultScreenPadding(),
          ),
        ],
      ),
    );
  }
}

class MorItemModel {
  final String icon;
  final String label;
  final void Function()? onTap;

  MorItemModel({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

List<MorItemModel> moreItemsList = [
  MorItemModel(
    icon: Assets.svgUser,
    label: LocaleKeys.profile,
    onTap: () {},
  ),
  MorItemModel(
    icon: Assets.svgPackageIcon,
    label: LocaleKeys.myPackage,
    onTap: () {},
  ),
  MorItemModel(
    icon: Assets.svgSuccessPartnerIcon,
    label: LocaleKeys.successPartners,
    onTap: () {
      Go.to(const SuccessPartnersScreen());
    },
  ),
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
