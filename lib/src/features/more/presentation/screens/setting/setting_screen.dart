import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/named_routes.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../auth/imports.dart';
import '../../../../home/home_screen.dart';
import '../../../../otp/presentation/otp.dart';
import '../../cubit/change_phone_manager.dart';
import '../../cubit/delete_account.dart';
import '../../widgets/more_item.dart';
import '../../widgets/change_phone_sheet_body.dart';
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
        onTap: () => Go.to( BlocProvider(
          create: (context) => ChangePhoneManagerCubit(),
          child: Navigator(
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(
                  builder: (context) => OtpScreen(
                    phone: UserCubit.instance.user.phone ?? '',
                    title: LocaleKeys.changePhoneNumber,
                    onEnterScreen: (context) =>
                        context.read<ChangePhoneManagerCubit>().manage(
                          phase: Phase.sendOld,
                          phone: UserCubit.instance.user.phone ?? '',
                        ),
                    onConfirmCode: (context, code) =>
                        context.read<ChangePhoneManagerCubit>().manage(
                          phase: Phase.checkOld,
                          code: code,
                          onSuccess: (data) => showBottomSheet(
                            context: context,
                            builder: (c) => const ChangePhoneSheetBody(),
                          ),
                        ),
                  ),
                ),
              ];
            },
            onGenerateRoute: (setting) {
              log('the route name is ${setting.name}');
              if(setting.name == NamedRoutes.oldPhoneOtpScreen.name){
                return MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      phone: UserCubit.instance.user.phone??'',
                      title: LocaleKeys.changePhoneNumber,
                      onEnterScreen: (context) =>
                          context.read<ChangePhoneManagerCubit>().manage(
                            phase: Phase.sendOld,
                            phone: UserCubit.instance.user.phone??'',
                          ),
                      onConfirmCode: (context, code) => context.read<ChangePhoneManagerCubit>().manage(
                        phase: Phase.checkOld,
                        code: code,
                        onSuccess: (data) => showBottomSheet(
                            context: context,
                            builder: (c) => const ChangePhoneSheetBody()
                        ),
                      ),
                    ),
                );

              }else if(setting.name == NamedRoutes.changePhone.name){
                return ModalBottomSheetRoute(
                    builder: (context) => const ChangePhoneSheetBody(),
                    isScrollControlled: true
                );

              }else if(setting.name == NamedRoutes.newPhoneOtpScreen.routeName){
                final args = setting.arguments as Map;
                return MaterialPageRoute(
                  builder: (context) => OtpScreen(
                    phone: args['phone'],
                    title: args['title'],
                    onEnterScreen: args['onEnterScreen'],
                    onConfirmCode: args['onConfirmCode']
                  ),
                );
              }

              return MaterialPageRoute(
                builder: (context) => const HomeScreen()
              );
            },
          ),

          // child: OtpScreen(
          //     phone: UserCubit.instance.user.phone??'',
          //     title: LocaleKeys.changePhoneNumber,
          //     onEnterScreen: (context) =>
          //         context.read<ChangePhoneManagerCubit>().manage(
          //           phase: Phase.sendOld,
          //           phone: UserCubit.instance.user.phone??'',
          //         ),
          //     onConfirmCode: (context, code) => context.read<ChangePhoneManagerCubit>().manage(
          //       phase: Phase.checkOld,
          //       code: code,
          //       onSuccess: (data) => showBottomSheet(
          //           context: context,
          //           builder: (c) => const ChangePhoneSheetBody()
          //       ),
          //     ),
          // ),
        )),
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
