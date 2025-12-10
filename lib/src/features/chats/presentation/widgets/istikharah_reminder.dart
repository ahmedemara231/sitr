import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../data/models/tip_model.dart';
import '../cubits/reminder_cubit.dart';

class IstikharahReminderSheet extends StatelessWidget {
  const IstikharahReminderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReminderCubit()..getReminder(),
      child: BlocBuilder<ReminderCubit, AsyncState<TipModel>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (data, context) => Column(
            spacing: 10.h,
            children: [
              AppText(data.title, color: AppColors.primary),
              AppText(data.tips),
              AppDefaultButton.withBackGroundColor(
                  title: LocaleKeys.confirm,
                  onTap: () => Go.back()
              )
            ],
          ),
        ),
      ),
    );
  }
}
