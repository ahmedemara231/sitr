import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/align_helper.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/riyal_price_text.dart';
import '../../../auth/imports.dart';
import '../../../packages/presentation/screens/subscription_screen.dart';
import '../cubit/logout_cubit.dart';
import '../cubit/wallet_cubit/charge_wallet_cubit.dart';
import '../cubit/wallet_cubit/fetch_wallet_cubit.dart';
import '../screens/setting/setting_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../widgets/custom_icon_inside_container.dart';

class MoreTabAppBar extends StatelessWidget {
  const MoreTabAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UserModel.isAuthenticated? 250.h : 100.h,
      child: Stack(
        children: [
          if(UserModel.isAuthenticated)
            Positioned(
              top: 115.h,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => FetchWalletCubit()..fetchWallet(),
                  ),
                  BlocProvider(
                    create: (context) => ChargeWalletCubit(),
                  )
                ],
                child: Builder(
                  builder: (context) {
                    return Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 24.5.h, left: 16.w, right: 16.w, bottom: 15.h),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                      ),
                      child: GestureDetector(
                        onTap: () async{
                          final result = await Go.to(BlocProvider.value(
                              value: context.read<FetchWalletCubit>(),
                              child: BlocProvider.value(
                                  value: context.read<ChargeWalletCubit>(),
                                  child: BlocBuilder<ChargeWalletCubit, AsyncState>(
                                      builder: (context, chargeState) => WalletScreen(
                                        balance: context.read<FetchWalletCubit>().state.data.toInt(),
                                      )))));

                          if(result == 'success'){
                            final result = await Go.to(SubscriptionScreen(
                                initialUrl: context.read<ChargeWalletCubit>().state.data)
                            );
                            if(result == 'success'){
                              context.read<FetchWalletCubit>().fetchWallet();
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.darkGoldenRod,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomIconInsideContainer(
                                icon: Assets.svgWallet,
                              ),
                              10.szW,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    LocaleKeys.balance,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                  ),
                                  BlocBuilder<FetchWalletCubit, AsyncState<num>>(
                                      builder: (context, state) => StatusBuilder(
                                        data: state,
                                        onSuccess: (data, context) =>
                                            RiyalPriceText(
                                                price: data.toString(),
                                                priceTextStyle: TextStyle(fontSize: 16.sp,),
                                                currencyTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp,),
                                            ),
                                      )
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 70.w,
                                height: 40.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: AppText(
                                  LocaleKeys.myBalance,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),

          Container(
            alignment: Alignment.center,
            height: 130.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.whiteGreyColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  LocaleKeys.more,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ).centerWidget,
                90.szW,
                Row(
                  children: [
                    if(UserModel.isAuthenticated)
                      InkWell(
                        onTap: () {
                          Go.to(const SettingScreen());
                        },
                        child: const CustomIconInsideContainer(
                          icon: Assets.svgSettingIcon,
                        ),
                      ),
                    8.szW,
                    InkWell(
                      onTap: (){
                        if(UserModel.isAuthenticated){
                          showDefaultBottomSheet(
                              child: BlocProvider(
                                create: (context) => LogoutCubit(),
                                child: AppBottomSheet.large(
                                    cancelBackgroundColor: AppColors.cancelColor,
                                    asyncCall: (context) => context.read<LogoutCubit>().logout(
                                        onSuccess: (msg) async{
                                          await UserCubit.instance.logout();
                                          Helpers.zegoService?.onUserLogout();
                                          Go.back(); // Close the bottom sheet first
                                          MessageUtils.showSnackBar(msg);
                                          Go.offAll(const LoginScreen());
                                        }
                                    ),
                                    btnTitle: LocaleKeys.confirm,
                                    upperWidget: Column(
                                      children: [
                                        SizedBox.square(
                                            dimension: 200.sp,
                                            child: Image.asset(Assets.imagesLogoutImage)
                                        ),
                                        AppText(LocaleKeys.areYouSureToLogout, fontWeight: FontWeight.w500),
                                      ],
                                    )
                                ),
                              )
                          );

                        }else{
                          Helpers.showUnauthenticatedSheet();
                        }
                      },
                      child: const CustomIconInsideContainer(
                        icon: Assets.svgLogOutIcon,
                      ),
                    ),
                  ],
                ),
                16.szW,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
