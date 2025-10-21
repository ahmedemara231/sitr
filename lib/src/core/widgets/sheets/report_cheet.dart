import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart' show Assets;
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../navigation/navigator.dart';
import '../../shared/report_cubit.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';
import '../svg_pic.dart';

class ReportSheet extends StatelessWidget {
  final int id;
  const ReportSheet({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: AppBottomSheet.large(
          asyncCall: (context) => context.read<ReportCubit>().report(
              id: id, report: 'report',
            onSuccess: () => Go.back()
          ),
          btnTitle: LocaleKeys.confirm,
          cancelBackgroundColor: AppColors.pink,
          upperWidget: Column(
            spacing: 30.h,
            children: [
              const SvgPic(assetName: Assets.svgReport),
              AppText(LocaleKeys.areYouSureToReportThisUser, fontSize: 18.sp,)
            ],
          )
      ),
    );
  }
}
