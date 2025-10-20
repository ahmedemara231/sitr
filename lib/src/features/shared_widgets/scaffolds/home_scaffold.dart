// part of '../imports/shared_widgets_imports.dart';
//
// class HomeScaffold extends StatelessWidget {
//   final String title;
//   final Widget body;
//   final bool isMainView;
//   final Widget? bottomNavigationBar;
//   const HomeScaffold({
//     super.key,
//     required this.title,
//     required this.body,
//     this.isMainView = false,
//     required this.bottomNavigationBar,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       body: _scaffoldBody(context),
//       bottomNavigationBar: bottomNavigationBar,
//     );
//   }
//
//   Widget _scaffoldBody(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: context.width,
//           margin: EdgeInsets.symmetric(vertical: AppMargin.mH10),
//           child: SafeArea(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 userInfo(context),
//                 notifictaionIcon(),
//               ],
//             ).paddingSymmetric(horizontal: AppPadding.pH12),
//           ),
//         ),
//         Expanded(child: body),
//       ],
//     );
//   }
//
//   Widget userInfo(BuildContext context) {
//     // final info = context.watch<UserCubit>().user;
//     return const Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Offstage(
//         //   offstage: !isMainView,
//         //   child: AppAssets.svg.hand.image(
//         //     height: AppSize.sH30,
//         //     width: AppSize.sH30,
//         //     fit: BoxFit.fill,
//         //   ),
//         // ),
//         // Text(
//         //   isMainView
//         //       ? context.read<UserCubit>().isUserLoggedIn
//         //           ? info.fullName
//         //           : LocaleKeys.dearVisitor.tr()
//         //       : title,
//         //   style: const TextStyle().setPrimaryColor.s16.bold.ellipsis,
//         // ),
//       ],
//     );
//   }
//
//   Widget notifictaionIcon() {
//     return InkWell(
//       onTap: () {
//         // if (context.read<UserCubit>().isUserLoggedIn) {
//         //   Go.to(const NotificationScreen());
//         // } else {
//         //   visitorPopUp(context);
//         // }
//       },
//       child: Container(
//         padding: EdgeInsets.all(AppPadding.pH2),
//         decoration: BoxDecoration(
//           color: const Color(0xFFB8EACB).withAlpha(20),
//           shape: BoxShape.circle,
//         ),
//         // child: Center(
//         //   child: AppAssets.svg.notification.svg(
//         //     height: AppSize.sW30,
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
