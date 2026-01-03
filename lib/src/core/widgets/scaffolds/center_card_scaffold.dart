import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/object.dart';
import '../../extensions/padding_extension.dart';
import '../pull_refresher.dart';
import 'app_scaffold.dart' show AppBackButton;

class CardProperties{
  final Color? color;
  CardProperties({this.color});
}

enum UpperView{appBar, upperWidget}
class CenterCardScaffold extends StatelessWidget {
  final CardProperties? cardProperties;
  final Widget upperWidget;
  final Widget body;
  final Widget? centerCardBody;
  final double? bodyTopPadding;
  final double? cardTopPadding;
  final Color? bodyColor;
  final EdgeInsetsGeometry? upperWidgetPadding;
  final bool? showBackButton;

  const CenterCardScaffold({
    super.key,
    required this.body,
    required this.upperWidget,
    this.bodyColor,
    this.upperWidgetPadding,
    this.showBackButton
  }) : centerCardBody = null, cardProperties = null, bodyTopPadding = null, cardTopPadding = null;

  const CenterCardScaffold.withCenteredCard({
    super.key,
    required this.upperWidget,
    required this.body,
    required this.centerCardBody,
    this.cardProperties,
    this.bodyTopPadding,
    this.cardTopPadding,
    this.showBackButton,
    this.bodyColor,
    this.upperWidgetPadding,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ScreenChildren(
          showBackButton: showBackButton,
          upperWidgetPadding: upperWidgetPadding,
          cardProperties: cardProperties,
          bodyColor: bodyColor,
          upperWidget: upperWidget,
          body: body,
          centerCardBody: centerCardBody,
          topPadding: bodyTopPadding,
          cardTopPadding: cardTopPadding,
        ),
      ),
    );
  }
}

class ScreenChildren extends StatelessWidget {
  final Widget upperWidget;
  final Widget body;
  final Widget? centerCardBody;
  final CardProperties? cardProperties;
  final double? topPadding;
  final double? cardTopPadding;
  final Color? bodyColor;
  final EdgeInsetsGeometry? upperWidgetPadding;
  final bool? showBackButton;

  const ScreenChildren({super.key,
    required this.body,
    required this.upperWidget,
    this.centerCardBody,
    this.cardProperties,
    this.topPadding,
    this.cardTopPadding,
    required this.bodyColor,
    required this.upperWidgetPadding,
    this.showBackButton
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Container(
                    width: context.width,
                    color: AppColors.whiteGreyColor,
                    child: Padding(
                      padding: upperWidgetPadding?? EdgeInsets.zero,
                      child: Stack(
                        children: [
                          upperWidget,
                          if(showBackButton ?? ModalRoute.of(context)!.canPop)
                            const AppBackButton(),
                        ],
                      ),
                    )
                ),
                Container(
                    width: context.width,
                    decoration: BoxDecoration(
                      color: bodyColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                    ),
                    child: centerCardBody.isNotNull?
                    body.defaultScreenPadding().paddingTop(topPadding ?? 40.h) :
                    body.defaultScreenPadding()
                ),
              ],
            ),

            if(centerCardBody.isNotNull)
              Container(
                  decoration: BoxDecoration(
                      color: cardProperties?.color??Colors.white,
                      borderRadius: BorderRadius.circular(12.r)
                  ),
                  child: centerCardBody
              ).paddingTop(cardTopPadding ?? 100.h).paddingSymmetric(horizontal: 12.w)
          ],
        )
      ],
    );
  }
}

