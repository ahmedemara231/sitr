import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../cubit/wallet_cubit/charge_wallet_cubit.dart';
import '../../cubit/wallet_cubit/fetch_wallet_cubit.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          FetchWalletCubit()
            ..fetchWallet(),
        ),
        BlocProvider(
          create: (context) => ChargeWalletCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteScaffoldBackground,

        appBar: customAppBar(appBarTitle: LocaleKeys.wallet),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SvgPic(
                assetName: Assets.svgWalletScreenImage,
              ),
              44.szH,
              AppText(
                LocaleKeys.yourCurrentBalance,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.darkGray,
              ),
              16.szH,
              BlocBuilder<FetchWalletCubit, AsyncState<num>>(
                builder: (context, state) {
                  return StatusBuilder(
                      data: state,
                      onSuccess: (data, context) {
                        return AppText(
                          data.toString(),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        );
                      });
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<ChargeWalletCubit, AsyncState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.r),
              child: AppLoadingButton(
                  asyncCall: (context) async {
                    await context.read<ChargeWalletCubit>().chargeWallet(2000);
                  },
                  title: LocaleKeys.rechargeWallet),
            );
          },
        ),
      ),
    );
  }
}
