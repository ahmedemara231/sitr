import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/align_helper.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart' show customAppBar;
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/contact_us_cubit/contact_us_cubit.dart';
import '../../widgets/socials.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late final TextEditingController controllerMessage;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllerMessage = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(),
      child: AppScaffold(
        appBarTitle: LocaleKeys.contactUs,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Languages.currentIsArabic?
                  Alignment.centerRight : Alignment.centerLeft,
                  child: AppText(
                    LocaleKeys.messageText,
                    color: AppColors.textBlack,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
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
                const FittedBox(
                  child: SocialsWidget()
                ),
              ],
            ).paddingAll(16.r),
          ),
        ),
        bottomBar: BlocBuilder<ContactUsCubit, AsyncState>(
          builder: (context, state) {
            return AppLoadingButton(
                asyncCall: (context) async {
                  if(!formKey.currentState!.validate())return;
                  final user = UserCubit.instance.user;
                  await context.read<ContactUsCubit>().contactUs(
                      name: user.name ?? '',
                      countryCode: '+966',
                      iso: "sa",
                      phone: user.phone ?? '',
                      message: controllerMessage.text
                  );
                },
                title: LocaleKeys.send
            );
          },
        ).paddingAll(16.r),
      ),
    );
  }
}
