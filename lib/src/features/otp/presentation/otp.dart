import 'dart:async';
import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import 'package:pinput/pinput.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/extensions/sized_box_helper.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/validators.dart';
import '../../../core/widgets/app_logo_widget.dart';
import '../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../core/widgets/buttons/app_loading_button.dart';
import '../models/resend_code_body.dart';
import 'cubits/resend_code_cubit.dart';
import 'widgets/otp_static_texts.dart';

class OtpScreen extends StatelessWidget {

  final String phone;
  final String title;
  final FutureOr<void> Function(BuildContext context)? onEnterScreen;
  final FutureOr<void> Function(BuildContext context, String code) onConfirmCode;
  // final FutureOr<void> Function(BuildContext context) onResendCodePress;

  const OtpScreen({super.key,
    required this.phone,
    required this.title,
    this.onEnterScreen,
    required this.onConfirmCode,
    // required this.onResendCodePress
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResendCodeCubit(),
      child: OtpScreenBody(
        phone: phone,
        title: title,
        onEnterScreen: onEnterScreen,
        onConfirmCode: onConfirmCode,
        // onResendCodePress: onResendCodePress,
      ),
    );
  }
}

class OtpScreenBody extends StatefulWidget {
  final String phone;
  final String title;
  final FutureOr<void> Function(BuildContext context)? onEnterScreen;
  final FutureOr<void> Function(BuildContext context, String code) onConfirmCode;
  // final FutureOr<void> Function(BuildContext context) onResendCodePress;
  const OtpScreenBody({super.key,
    required this.phone,
    required this.title,
    this.onEnterScreen,
    required this.onConfirmCode,
    // required this.onResendCodePress
  });

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {

  late TextEditingController pinCont;
  late EasyTimerController _timeCont;

  @override
  void initState() {
    pinCont = TextEditingController();
    _timeCont = EasyTimerController();
    super.initState();
  }

  @override
  void dispose() {
    pinCont.dispose();
    _timeCont.dispose();
    super.dispose();
  }

  final PinTheme? defaultPinTheme = PinTheme(
      width: 55.w,
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.transparent),
          color: Colors.grey[100]
      )
  );

  final _formKey = GlobalKey<FormState>();
  bool _canResend = false;
  String code = '';
  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold(
        upperWidget: Column(
          spacing: 12.h,
          children: [
            const AppLogoWidget(),
            OtpStaticTexts(phone: widget.phone),
          ],
        ),
        body: SizedBox(
          height: context.height * .7,
          child: Column(
            spacing: 5.h,
            children: [
              Align(
                alignment: Helpers.getAlignment,
                child: AppText(
                  LocaleKeys.activationCode,
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Pinput(
                  separatorBuilder: (n) => 20.szW,
                  defaultPinTheme: defaultPinTheme,
                  controller: pinCont,
                  onChanged: (val) => code = val,
                  validator: Validators.validateEmpty,
                ),
              ),
              16.szH,

              AppLoadingButton(
                title: LocaleKeys.confirm,
                asyncCall: (context) async{
                  if (_formKey.currentState!.validate()) {
                    await widget.onConfirmCode.call(context, code);
                  }
                },
              ),

              EasyTimerCount.builder(
                  controller: _timeCont,
                  duration: const EasyTime(minutes: 1),
                  builder: (time) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(LocaleKeys.remainingTime, color: Colors.grey),
                      5.szW,
                      AppText(time, fontWeight: FontWeight.w500,),
                      BlocListener<ResendCodeCubit, AsyncState>(
                        listener: (context, state) => Helpers.manageBlocListener(
                          state.status,
                        ),
                        child: TextButton(
                            onPressed: _canResend? () {
                              context.read<ResendCodeCubit>().resendOtp(body: ResendCodeBody(phone: widget.phone));
                              _timeCont.restart();
                              setState(() => _canResend = false);
                            } : null,
                            child: AppText(
                              LocaleKeys.resendCode,
                              color: _canResend? AppColors.primary : Colors.grey,
                            )
                        ),
                      ),
                    ],
                  ),
                  onTimerStarts: (context) async => widget.onEnterScreen?.call(context),
                  onTimerEnds: (context) => setState(() => _canResend = true)
              ),
            ],
          ),
        )
    );
  }
}
