import 'dart:async';
import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import 'package:pinput/pinput.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../widgets/otp_static_texts.dart';

class OtpScreen extends StatelessWidget {

  final String title;
  final FutureOr<void> Function(BuildContext context)? onEnterScreen;
  final FutureOr<void> Function(BuildContext context, String code) onConfirmCode;
  final FutureOr<void> Function(BuildContext context) onResendCodePress;

  const OtpScreen({super.key,
    required this.title,
    this.onEnterScreen,
    required this.onConfirmCode,
    required this.onResendCodePress
  });

  @override
  Widget build(BuildContext context) {
    return OtpScreenBody(
      title: title,
      onEnterScreen: onEnterScreen,
      onConfirmCode: onConfirmCode,
      onResendCodePress: onResendCodePress,
    );
  }
}

class OtpScreenBody extends StatefulWidget {
  final String title;
  final FutureOr<void> Function(BuildContext context)? onEnterScreen;
  final FutureOr<void> Function(BuildContext context, String code) onConfirmCode;
  final FutureOr<void> Function(BuildContext context) onResendCodePress;
  const OtpScreenBody({super.key,
    required this.title,
    this.onEnterScreen,
    required this.onConfirmCode,
    required this.onResendCodePress
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
  void didChangeDependencies() {
    widget.onEnterScreen?.call(context);
    super.didChangeDependencies();
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
    return AuthScaffold(
        upperWidget: SizedBox(
          height: context.height * .2,
          child: Column(
            spacing: 12.h,
            children: const [
              AppLogoWidget(),
              OtpStaticTexts(),
            ],
          ),
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
                asyncCall: () async{
                  if (_formKey.currentState!.validate()) {
                    await widget.onConfirmCode.call(context, code);
                  }
                },
              ),

              EasyTimerCount.builder(
                  controller: _timeCont,
                  duration: const EasyTime(minutes: 1),
                  builder: (time) => Row(
                    spacing: 5.w,
                    children: [
                      AppText(LocaleKeys.remainingTime, color: Colors.grey),
                      AppText(time, fontWeight: FontWeight.w500,),
                      TextButton(
                          onPressed: _canResend? () {
                            widget.onResendCodePress.call(context);
                            _timeCont.restart();
                            setState(() => _canResend = false);
                          } : null,
                          child: AppText(
                            LocaleKeys.resendCode,
                            color: _canResend? AppColors.primary : Colors.grey,
                          )
                      ),
                    ],
                  ),
                  onTimerStarts: (context) async {},
                  onTimerEnds: (context) => setState(() => _canResend = true)
              ),
            ],
          ),
        )
    );
  }
}
