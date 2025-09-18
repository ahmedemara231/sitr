import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/align_helper.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
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
                  height: 86.h,
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
                          AppText(
                            '2500 ${LocaleKeys.sar}',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
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
            height: 129.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.whiteGreyColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AppText(
                    LocaleKeys.more,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ).centerWidget,
                ),
                const CustomIconInsideContainer(
                  icon: Assets.svgSettingIcon,
                ),
                8.szW,
                const CustomIconInsideContainer(
                  icon: Assets.svgLogOutIcon,
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
