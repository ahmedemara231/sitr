import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/config_imports.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/object.dart';
import '../../extensions/padding_extension.dart';
import 'app_scaffold.dart' show AppBackButton;

class CardProperties{
  final Color? color;
  CardProperties({this.color});
}

enum UpperView{appBar, upperWidget}
class CenterCardScaffold extends StatelessWidget {
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
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
    this.physics,
    this.upperWidgetPadding,
    this.showBackButton,
    this.scrollController,
  }) : centerCardBody = null, cardProperties = null, bodyTopPadding = null, cardTopPadding = null;

  const CenterCardScaffold.withCenteredCard({
    super.key,
    required this.upperWidget,
    required this.body,
    required this.centerCardBody,
    this.physics,
    this.cardProperties,
    this.bodyTopPadding,
    this.cardTopPadding,
    this.showBackButton,
    this.bodyColor,
    this.scrollController,
    this.upperWidgetPadding,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ScreenChildren(
          physics: physics,
          showBackButton: showBackButton,
          upperWidgetPadding: upperWidgetPadding,
          cardProperties: cardProperties,
          bodyColor: bodyColor,
          upperWidget: upperWidget,
          body: body,
          scrollController: scrollController,
          centerCardBody: centerCardBody,
          topPadding: bodyTopPadding,
          cardTopPadding: cardTopPadding,
        ),
      ),
    );
  }
}

class ScreenChildren extends StatelessWidget {
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
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
    this.scrollController,
    this.cardProperties,
    this.physics,
    this.topPadding,
    this.cardTopPadding,
    required this.bodyColor,
    required this.upperWidgetPadding,
    this.showBackButton
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: physics,
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

/// A sliver-based variant of CenterCardScaffold that supports nested scrolling.
/// This allows inner scrollable widgets (like paginated lists) to take full screen
/// when the header content is scrolled away.
class SliverCenterCardScaffold extends StatelessWidget {
  final CardProperties? cardProperties;
  final Widget upperWidget;
  final Widget Function(BuildContext context) bodyBuilder;
  final Widget? centerCardBody;
  final double? bodyTopPadding;
  final double? cardTopPadding;
  final Color? bodyColor;
  final EdgeInsetsGeometry? upperWidgetPadding;
  final bool? showBackButton;
  final Widget? headerContent;

  const SliverCenterCardScaffold({
    super.key,
    required this.upperWidget,
    required this.bodyBuilder,
    this.centerCardBody,
    this.cardProperties,
    this.bodyTopPadding,
    this.cardTopPadding,
    this.showBackButton,
    this.bodyColor,
    this.upperWidgetPadding,
    this.headerContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: context.width,
                        color: AppColors.whiteGreyColor,
                        child: Padding(
                          padding: upperWidgetPadding ?? EdgeInsets.zero,
                          child: Stack(
                            children: [
                              upperWidget,
                              if (showBackButton ?? ModalRoute.of(context)!.canPop)
                                const AppBackButton(),
                            ],
                          ),
                        ),
                      ),
                      if (headerContent != null)
                        Container(
                          width: context.width,
                          decoration: BoxDecoration(
                            color: bodyColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                          ),
                          child: centerCardBody.isNotNull
                              ? headerContent!.defaultScreenPadding().paddingTop(bodyTopPadding ?? 40.h)
                              : headerContent!.defaultScreenPadding(),
                        ),
                    ],
                  ),
                  if (centerCardBody.isNotNull)
                    Container(
                      decoration: BoxDecoration(
                        color: cardProperties?.color ?? Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: centerCardBody,
                    ).paddingTop(cardTopPadding ?? 100.h).paddingSymmetric(horizontal: 12.w),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                decoration: BoxDecoration(
                  color: bodyColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: bodyBuilder(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

