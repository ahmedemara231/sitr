import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../core/extensions/padding_extension.dart';
import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../../core/widgets/sheets/show_brands_sheet.dart';
import '../../../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../../../chats/data/chat_sheet_manager.dart';
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
    return Column(
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
            validator: Validators.validateEmpty,
            upperTitle: '',
          ),
        ),
        AppLoadingButton(
            asyncCall: (context) async{
              if(_formKey.currentState!.validate()){
                ChatSheetManager.show(
                  child: BlocProvider(
                    create: (context) => ChargeWalletCubit(),
                    child: ShowBrandsSheet(
                        onPay: (context, brandId) async => await context.read<ChargeWalletCubit>().chargeWallet(
                            _amountCont.text,
                            brandId,
                            onSuccess: (url)async{
                              final result = await Go.to(SubscriptionScreen(initialUrl: url));
                              if(result == 'success'){
                                await ChatSheetManager.show(
                                    child: SuccessSheet(
                                      isInAuth: false,
                                      upperText: Text(LocaleKeys.walletChargedSuccessfully),
                                    )
                                );

                                Go.back('success');
                              }
                            }
                        )
                    ),
                  ),
                );
              }
            },
            title: LocaleKeys.confirm
        )
      ],
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }
}