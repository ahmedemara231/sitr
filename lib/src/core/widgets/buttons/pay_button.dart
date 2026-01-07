class PayButton extends StatelessWidget {
  const PayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoadingButton(
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
      );
  }
}
