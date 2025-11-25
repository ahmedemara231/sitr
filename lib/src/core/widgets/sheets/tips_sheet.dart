import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/chats/presentation/cubits/get_tips_cubit.dart';
import '../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../extensions/padding_extension.dart';
import '../../helpers/status_builder.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';

class TipsSheet extends StatelessWidget {
  final String title;
  final String path;
  final FutureOr<void> Function(BuildContext context) onConfirm;
  final String? btnTitle;

  const TipsSheet({
    super.key,
    required this.title,
    required this.path,
    required this.onConfirm,
    this.btnTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTipsCubit()..getTips(path),
      child: BlocBuilder<GetTipsCubit, AsyncState<String>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (tips, context) => Column(
            spacing: 10.h,
            children: [
              AppText(title, fontSize: 22.sp, fontWeight: FontWeight.w500),
              Html(data: tips),
              AppLoadingButton(
                  title: btnTitle ?? LocaleKeys.confirm,
                  asyncCall: (context) async{
                    await onConfirm.call(context);
                  })
            ],
          ).paddingAll(10.r),
        ),
      ),
    );
  }
}