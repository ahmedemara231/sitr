import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';
import '../../models/package.dart';

class PackageCard extends StatelessWidget {
  final Package package;
  final bool isSubscribed;

  const PackageCard({super.key, required this.package, this.isSubscribed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.forth
      ),
      child: Column(
        children: [
          ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(Assets.svgPackagesScreenImageBackground),
                SvgPicture.asset(Assets.svgPackagesScreenImage).paddingAll(7),
              ],
            ),
            title: const AppText('باقة ذهبية', fontWeight: FontWeight.w500),
            subtitle:  const AppText.withIcon(icon: Icon(Icons.calendar_month, color: AppColors.primary,), text: '30 يوم', color: AppColors.primary,),
          ),
          Row(
            spacing: 10.w,
            children: [
              AppText(LocaleKeys.amount, color: Colors.grey),
              const AppText( '3000 ريال', color: AppColors.primary, fontWeight: FontWeight.bold),
              const Spacer(),
                InkWell(
                  onTap: () {
                    // Go.to(PaymentScreen(
                    //   paymentFromType: PaymentFromType.package,
                    //   price: double.parse(package.price),
                    //   packageId: package.id,
                    // ));
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: AppText(
                        !isSubscribed?
                        LocaleKeys.subscribe :
                        LocaleKeys.renewPackage,
                        color: AppColors.primary
                    ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                )
            ],
          )
        ],
      ).paddingAll(10.r),
    );
  }
}
