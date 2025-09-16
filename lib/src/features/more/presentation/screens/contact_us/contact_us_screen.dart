import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/align_helper.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/lancher_helper.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart' show customAppBar;
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appBarTitle: LocaleKeys.contactUs),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            LocaleKeys.messageText,
            color: AppColors.textBlack,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
          8.szH,
          DefaultTextField(
            title: LocaleKeys.pleaseAttachText,
            fillColor: AppColors.whiteGreyColorProMax,
            borderColor: Colors.transparent,
            maxLines: 9,
            inputType: TextInputType.multiline,
            validator: (value) => Validators.validateEmpty(value),
          ),
          27.szH,
          AppText(
            LocaleKeys.youCanContactUsThroughTheFollowingChannels,
            color: AppColors.textBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ).centerWidget,
          20.szH,
          Wrap(
            runSpacing: 15.0.h,
            children: List.generate(
              iconPath.length,
                  (index) => Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: actions[index],
                  child: IconWidget(
                    icon: iconPath[index],
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ).paddingAll(16.r),
      bottomNavigationBar: AppLoadingButton(
          asyncCall: (context) async {}, title: LocaleKeys.send)
          .paddingAll(16.r),    );
  }
}

List<String> iconPath = [
  Assets.svgFacebook,
  Assets.svgWhatsApp,
  Assets.svgSnapchat,
  Assets.svgContactPhone,
  Assets.svgInstgram,
  Assets.svgTwiter,
  Assets.svgTiktok,
];
List<VoidCallback> actions = [
      () => LauncherHelper.launchFacebook('khalid.gamal.9615'),
      () => LauncherHelper.launchWhatsApp('966500500500'),
      () => LauncherHelper.launchSnapchat('userName'),
      () => LauncherHelper.callPhone( phone: '966500500500'),
      () => LauncherHelper.launchInstagram('flutter.dev'),
      () => LauncherHelper.launchTwitter('userName'),
      () => LauncherHelper.launchTikTok('userName'),

];