import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/align_helper.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/lancher_helper.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart' show customAppBar;
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/contact_us_cubit/contact_us_cubit.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final TextEditingController controllerMessage = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.whiteScaffoldBackground,
        appBar: customAppBar(appBarTitle: LocaleKeys.contactUs),
        body: Form(
          key: formKey,
          child: Column(
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
                controller: controllerMessage,
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
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ).centerWidget,
              20.szH,
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    iconPath.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: GestureDetector(
                        onTap: actions[index],
                        child: IconWidget(
                          icon: iconPath[index],
                          width: 30.w,
                          height: 30.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).paddingAll(16.r),
        ),
        bottomNavigationBar: BlocBuilder<ContactUsCubit, AsyncState>(
          builder: (context, state) {
            return AppLoadingButton(
                asyncCall: (context) async {
                  if(!formKey.currentState!.validate())return;
                  await context.read<ContactUsCubit>().contactUs(
                      name: 'name',
                      countryCode: '+966',
                      iso: "sa",
                      phone: "500500500",
                      message: controllerMessage.text);
                },
                title: LocaleKeys.send);
          },
        ).paddingAll(16.r),
      ),
    );
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
  () => LauncherHelper.callPhone(phone: '966500500500'),
  () => LauncherHelper.launchInstagram('flutter.dev'),
  () => LauncherHelper.launchTwitter('userName'),
  () => LauncherHelper.launchTikTok('userName'),
];
