import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';

import '../../../../config/res/config_imports.dart';
import '../../app_text.dart';

class LoadingButton extends StatelessWidget {
  final Future<void> Function(BuildContext context) call;
  final Color btnColor;
  final double borderRadius;
  final double height;
  final double width;
  final double contentGap;
  final Widget loadingWidget;
  final Widget idleWidget;

  LoadingButton({super.key,
    required this.call,
    this.btnColor = AppColors.primary,
    this.borderRadius = 0.0,
    this.height = 40,
    this.width = double.infinity,
    this.contentGap = 12,
    this.idleWidget = const AppText('Confirm'),
    this.loadingWidget = const CircularProgressIndicator(
      color: Colors.white,
    )
  });

  EasyButtonState _easyButtonState = EasyButtonState.idle;
  Future<void> asyncCall(BuildContext context)async{
    try {
      _easyButtonState = EasyButtonState.loading;
      await call(context);
      _easyButtonState = EasyButtonState.idle;
    } finally {
      _easyButtonState = EasyButtonState.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyButton(
        state: _easyButtonState,
        buttonColor: btnColor,
        borderRadius: borderRadius,
        contentGap: contentGap,
        height: height,
        width: width,
        useWidthAnimation: true,
        useEqualLoadingStateWidgetDimension: true,
        onPressed: () => asyncCall(context),
        idleStateWidget: idleWidget,
        loadingStateWidget: SizedBox.square(
            dimension: 20,
            child: loadingWidget
        )
    );
  }
}
