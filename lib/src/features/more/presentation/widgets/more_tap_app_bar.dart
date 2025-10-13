import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/align_helper.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../auth/imports.dart';
import '../cubit/logout_cubit.dart';
import '../cubit/wallet_cubit/fetch_wallet_cubit.dart';
import '../screens/wallet/wallet_screen.dart';
import '../widgets/custom_icon_inside_container.dart';

class MoreTabAppBar extends StatelessWidget {
  const MoreTabAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: Stack(
        children: [
          Positioned(
            top: 115.h,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: 24.5.h, left: 16.w, right: 16.w, bottom: 15.h),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: GestureDetector(
                onTap: () {
                  Go.to(const WalletScreen());
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
                          BlocProvider(
                            create: (context) => FetchWalletCubit()..fetchWallet(),
                            child: BlocBuilder<FetchWalletCubit, AsyncState<num>>(
                                builder: (context, state) => StatusBuilder(
                                    data: state,
                                    onSuccess: (data, context) => AppText(
                                      '$data ${LocaleKeys.sar}',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                )
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
                55.szW,
                Row(
                  children: [
                    const CustomIconInsideContainer(
                      icon: Assets.svgSettingIcon,
                    ),
                    8.szW,
                    InkWell(
                      onTap: (){
                        showDefaultBottomSheet(
                            child: BlocProvider(
                              create: (context) => LogoutCubit(),
                              child: AppBottomSheet.large(
                                  cancelBackgroundColor: AppColors.cancelColor,
                                  asyncCall: (context) => context.read<LogoutCubit>().logout(
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
                                          child: Image.asset(Assets.imagesLogoutImage)
                                      ),
                                      AppText(LocaleKeys.areYouSureToLogout, fontWeight: FontWeight.w500),
                                    ],
                                  )
                              ),
                            )
                        );
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
