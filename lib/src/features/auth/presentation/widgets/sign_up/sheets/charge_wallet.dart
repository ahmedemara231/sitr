import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/extensions/num.dart';
import '../../../../../../core/extensions/padding_extension.dart';
import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/shared/get_paymeny_brands_cubit.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../../core/widgets/custom_messages.dart';
import '../../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../../../core/widgets/radio_bottom_sheet.dart';
import '../../../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../../../more/presentation/cubit/wallet_cubit/charge_wallet_cubit.dart';
import '../../../../../packages/presentation/screens/subscription_screen.dart';

class ChargeWalletSheet extends StatefulWidget {
  const ChargeWalletSheet({super.key});

  @override
  State<ChargeWalletSheet> createState() => ChargeWalletSheetState();
}

class ChargeWalletSheetState extends State<ChargeWalletSheet> {
  late final TextEditingController _amountCont;

  @override
  void initState() {
    _amountCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountCont.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChargeWalletCubit()),
        BlocProvider(create: (context) => PaymentBrands()),
      ],
      child: Column(
        spacing: 10.h,
        children: [
          AppText(LocaleKeys.chargeWallet),
          Form(
            key: _formKey,
            child: DefaultTextField.withTitle(
              title: LocaleKeys.enterAmount,
              prefixIcon: const Icon(Icons.wallet),
              controller: _amountCont,
              inputType: TextInputType.number,
              validator: Validators.validateEmpty, upperTitle: '',
            ),
          ),
          AppLoadingButton(
              asyncCall: (context) async{
                if(_formKey.currentState!.validate()){
                  await context.read<PaymentBrands>().get(
                    onSuccess: (data) => showDefaultBottomSheet(
                        child: RadioSelectionWidget<int>(
                          selectedBackgroundColor: AppColors.primary.withOpacity(.2),
                            title: LocaleKeys.choosePaymentMethod,
                            onSubmit: (ctx, brandId) async{
                            await context.read<ChargeWalletCubit>().chargeWallet(
                                _amountCont.text,
                                brandId,
                                onSuccess: (url)async{
                                  final result = await Go.to(SubscriptionScreen(initialUrl: url));
                                  if(result == 'success'){
                                    await showDefaultBottomSheet(
                                        child: SuccessSheet(
                                          isInAuth: false,
                                          upperText: Text(LocaleKeys.walletChargedSuccessfully),
                                        )
                                    );
                                    Go.back('success');
                                  }
                                }
                              );
                            },
                            values: data.map((e) => e.id??0).toList(),
                            showSubmitButton: true,
                            titles: List.generate(
                                data.length,
                                    (i) => Expanded(child: Row(
                                      spacing: 10.w,
                                      children: [
                                        CachedImage(
                                            width: 50.w,
                                            height: 50.h,
                                            url: data[i].image??''
                                        ),
                                        AppText(data[i].name??''),
                                      ],
                                    ))
                            )
                        )
                    )
                  );
                }
              },
              title: LocaleKeys.confirm
          )
        ],
      ).paddingBottom(MediaQuery.of(context).viewInsets.bottom),
    );
  }
}