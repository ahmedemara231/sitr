import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/padding_extension.dart';

enum UpperView{appBar, upperWidget}
class AuthScaffold extends StatelessWidget {
  final Widget? upperWidget;
  final Widget body;

  const AuthScaffold({
    super.key,
    required this.body,
    this.upperWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ScreenChildren(
          upperWidget: upperWidget,
          body: body,
        ),
      ),
    );
  }
}

class ScreenChildren extends StatelessWidget {
  final Widget? upperWidget;
  final Widget body;

  const ScreenChildren({super.key,
    required this.body,
    this.upperWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            width: context.width,
            color: AppColors.whiteGreyColor,
            child: upperWidget!.paddingAll(20.r)
        ),
        Container(
          width: context.width,
            height: context.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
            ),
            child: body.defaultScreenPadding()
        ),
      ],
    );
  }
}

