import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/svg_pic.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:customAppBar(appBarTitle: LocaleKeys.wallet) ,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgPic( assetName:Assets.svgWalletScreenImage, ),
            44.szH,
            AppText(
              LocaleKeys.yourCurrentBalance,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGray,
            ),
            16.szH,
            const AppText(
              '2500 ريال',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.all(16.r),
        child: AppLoadingButton(
            asyncCall: (context) async {}, title: LocaleKeys.rechargeWallet),
      ),
    );
  }
}
