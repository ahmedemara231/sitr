import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/res/config_imports.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import 'app_text.dart';

enum UpperView{appBar, upperWidget}
class AppScaffold extends StatelessWidget {
  final bool isScrollable;
  final String? title;
  final bool? centerTitle;
  final UpperView? upperView;
  final List<Widget>? actions;
  final Widget? upperWidget;
  final Widget body;
  const AppScaffold.withAppBar({
    super.key,
    required this.body,
    this.isScrollable = false,
    this.title,
    this.actions,
    this.centerTitle,
  }) : upperView = UpperView.appBar, upperWidget = null;
  const AppScaffold.withUpperWidget({
    super.key,
    required this.body,
    this.isScrollable = false,
    this.upperWidget
  }) : upperView = UpperView.upperWidget,
        title = null, actions = null, centerTitle = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isScrollable? SingleChildScrollView(
          child: ScreenChildren(
            title: title,
            centerTitle: centerTitle,
            upperView: upperView,
            actions: actions,
            upperWidget: upperWidget,
            body: body,
          ),
        ) : ScreenChildren(
          title: title,
          centerTitle: centerTitle,
          upperView: upperView,
          actions: actions,
          upperWidget: upperWidget,
          body: body,
        ),
      ),
    );
  }
}

class ScreenChildren extends StatelessWidget {
  final String? title;
  final bool? centerTitle;
  final UpperView? upperView;
  final List<Widget>? actions;
  final Widget? upperWidget;
  final Widget body;
  const ScreenChildren({super.key,
    required this.body,
    this.title,
    this.actions,
    this.centerTitle,
    this.upperView = UpperView.appBar,
    this.upperWidget
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        upperView == UpperView.appBar?
        AppBar(
          leading: Container(
            width: 70.w,
            height: 70.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_outlined),
          ),
          title: AppText( title?? '', fontWeight: FontWeight.w500),
          actions: actions,
          centerTitle: title != null? centerTitle?? true : null,
        ) :
        IntrinsicHeight(
            child: Container(
                width: context.width,
                color: AppColors.whiteGreyColor,
                child: upperWidget!.paddingAll(12)
            )
        ),
        body,
      ],
    );
  }
}

