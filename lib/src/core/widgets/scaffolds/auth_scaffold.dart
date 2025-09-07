import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/object.dart';
import '../../extensions/padding_extension.dart';

enum UpperView{appBar, upperWidget}
class CenterCardScaffold extends StatelessWidget {
  final Widget upperWidget;
  final Widget body;
  final Widget? centerCardBody;

  const CenterCardScaffold({
    super.key,
    required this.body,
    required this.upperWidget,
  }) : centerCardBody = null;

  const CenterCardScaffold.withCenteredCard({
    super.key,
    required this.upperWidget,
    required this.body,
    required this.centerCardBody
});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ScreenChildren(
          upperWidget: upperWidget,
          body: body,
          centerCardBody: centerCardBody,
        ),
      ),
    );
  }
}

class ScreenChildren extends StatelessWidget {
  final Widget upperWidget;
  final Widget body;
  final Widget? centerCardBody;

  const ScreenChildren({super.key,
    required this.body,
    required this.upperWidget,
    this.centerCardBody
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
                    child: upperWidget.paddingAll(20.r)
                ),
                Container(
                    width: context.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                    ),
                    child: centerCardBody.isNotNull?
                    body.defaultScreenPadding().paddingTop(100.h) :
                    body.defaultScreenPadding()
                ),
              ],
            ),

            if(centerCardBody.isNotNull)
              Card(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r)
                  ),
                  child: centerCardBody!.paddingAll(12.r)
                ),
              ).paddingTop(100.h).paddingSymmetric(horizontal: 12.w)
          ],
        )
      ],
    );
  }
}

