import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/lancher_helper.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../cubit/get_socials.dart';
import '../models/social.dart';

class SocialsWidget extends StatelessWidget {
  const SocialsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GetSocialsCubit()..getSocials(),
        child: BlocBuilder<GetSocialsCubit, AsyncState<List<Social>>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (socials, context) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                socials.length,
                    (index) => Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () => LauncherHelper.launchURL(url: socials[index].link),
                    child: IconWidget(
                      icon: socials[index].icon,
                      width: 30.w,
                      height: 30.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
