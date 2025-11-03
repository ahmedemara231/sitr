import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/chats/presentation/cubits/get_tips_cubit.dart';
import '../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../extensions/padding_extension.dart';
import '../../helpers/status_builder.dart';
import '../app_text.dart';
import '../buttons/custom_app_buttons/default_button.dart';

class TipsSheet extends StatelessWidget {
  final String title;
  final String path;
  final void Function(BuildContext context) onConfirm;
  const TipsSheet({
    super.key,
    required this.title,
    required this.path,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTipsCubit()..getTips(path),
      child: BlocBuilder<GetTipsCubit, AsyncState<List<String>>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (tips, context) => Column(
            children: [
              AppText(title, fontSize: 22.sp, fontWeight: FontWeight.w500),
              Column(
                children: List.generate(
                    tips.length,
                        (i) => AppText(tips[i])
                            .paddingSymmetric(vertical: 10.h)
                ),
              ),
              AppDefaultButton.withBackGroundColor(
                title: LocaleKeys.confirm,
                onTap: () {
                  onConfirm.call(context);
                })
            ],
          ),
        ),
      ),
    );
  }
}