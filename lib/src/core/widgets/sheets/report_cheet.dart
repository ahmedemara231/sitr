import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart' show Assets;
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../helpers/validators.dart';
import '../../navigation/navigator.dart';
import '../../shared/report_cubit.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';
import '../svg_pic.dart';
import '../text_fields/default_text_field.dart';

class ReportSheet extends StatefulWidget {
  final int id;
  const ReportSheet({super.key, required this.id});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {

  late final TextEditingController _reportController;

  @override
  void initState() {
    _reportController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: AppBottomSheet.large(
          asyncCall: (context) => _formKey.currentState!.validate()? context.read<ReportCubit>().report(
              id: widget.id, report: _reportController.text,
            onSuccess: () => Go.back()
          ) : null,
          btnTitle: LocaleKeys.confirm,
          cancelBackgroundColor: AppColors.pink,
          upperWidget: Column(
            spacing: 30.h,
            children: [
              const SvgPic(assetName: Assets.svgReport),
              Form(
                key: _formKey,
                child: DefaultTextField.withTitle(
                  validator: Validators.validateEmpty,
                    upperTitle: LocaleKeys.reportReason,
                    inputType: TextInputType.multiline,
                    action: TextInputAction.newline,
                    controller: _reportController
                ),
              ),
              AppText(LocaleKeys.areYouSureToReportThisUser, fontSize: 18.sp,)
            ],
          )
      ),
    );
  }
}
