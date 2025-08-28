import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../packages_screen.dart';

class PackageWidget extends StatelessWidget {
  final ScreenType type;
  const PackageWidget({super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteGreyColorProMax,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteGreyColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const SvgPic(assetName: Assets.svgPackageIcon).paddingAll(10.r)),
            title: AppText('Package name', fontWeight: FontWeight.bold, fontSize: 16.sp,),
            subtitle: Row(
              spacing: 5.w,
              children: const [
                Icon(Icons.calendar_month_outlined, color: AppColors.primary,),
                AppText('30 يوم', color: AppColors.primary,)
              ],
            ),
          ),
          Row(
            spacing: 7.w,
            children: [
              AppText(LocaleKeys.price, color: Colors.grey),
              const AppText('price', fontWeight: FontWeight.bold, color: AppColors.primary,),
              const Spacer(),
              SizedBox(
                width: context.width * .5,
                height: 40.h,
                child: AppDefaultButton.withBorderColor(
                    title: type == ScreenType.view?
                    LocaleKeys.subscribeToPackage : LocaleKeys.renewPackage,
                    onTap: (){}
                ),
              )
            ],
          )
        ],
      ).paddingAll(16.r)

    );
  }
}
