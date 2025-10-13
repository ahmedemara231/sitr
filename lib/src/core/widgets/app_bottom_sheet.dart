import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../navigation/navigator.dart';
import 'buttons/app_loading_button.dart';
import 'buttons/custom_app_buttons/default_button.dart';

enum AppBottomSheetSize {small ,large}
class AppBottomSheet extends StatelessWidget {
  final AppBottomSheetSize size;
  final FutureOr<void> Function(BuildContext) asyncCall;
  final String btnTitle;
  final Widget upperWidget;
  final Color? backgroundColor;

  const AppBottomSheet.small({super.key,
    required this.asyncCall,
    required this.btnTitle,
    required this.upperWidget,
  }) : size = AppBottomSheetSize.small, backgroundColor = null;

  const AppBottomSheet.large({super.key,
    required this.asyncCall,
    required this.btnTitle,
    required this.upperWidget,
    this.backgroundColor
  }) : size = AppBottomSheetSize.large;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          color: Colors.white,
        ),
        child: Column(
          spacing: 10.h,
          children: [
            upperWidget,

            if(size == AppBottomSheetSize.small)
              AppLoadingButton(
                  asyncCall: (context) async => await asyncCall.call(context),
                  title: btnTitle
              )
            else
              _AppSheetButtons(
                  asyncCall: asyncCall,
                   backgroundColor: backgroundColor,
                  title: btnTitle
              )
          ],
        ),
      ),
    );
  }
}

class _AppSheetButtons extends StatelessWidget {

  final FutureOr<void> Function(BuildContext) asyncCall;
  final String title;
  final Color? backgroundColor;

  const _AppSheetButtons({
    required this.asyncCall,
    required this.title,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 7.w,
      children: [
        Expanded(
            child: AppLoadingButton(
                asyncCall: (context) async => await asyncCall.call(context),
                title: title
            )
        ),
        Expanded(
          child: AppDefaultButton.withBackGroundColor(
              title: LocaleKeys.cancel,
              backgroundColor: backgroundColor,
              onTap: () => Go.back()
          ),
        )
      ],
    );
  }
}

