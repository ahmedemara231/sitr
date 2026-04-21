import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_text.dart';
import 'filter_icon.dart';

class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(LocaleKeys.welcome, fontSize: 12.sp),
              AppText(
                UserCubit.instance.user.name ?? '',
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ],
          ),
          const Spacer(),
          const FilterButton(),
        ],
      ),
    );
  }
}
