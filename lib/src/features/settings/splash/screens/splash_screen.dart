// part of '../imports/view_imports.dart';
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<SplashCubit>(
//       create: (context) => SplashCubit(),
//       child: const _SplashView(),
//     );
//   }
// }
//
// class _SplashView extends StatelessWidget {
//   const _SplashView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             width: context.width,
//             height: context.height,
//             child: AppAssets.lottie.loading.loading3.lottie(
//               fit: BoxFit.fill,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
