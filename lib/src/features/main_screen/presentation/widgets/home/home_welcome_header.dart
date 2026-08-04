import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/promotion_badge.dart';
import '../../../../promotions/data/models/promotion_badge_model.dart';
import '../../../../promotions/presentation/cubits/promotion_badge_cubit.dart';
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
              Row(
                spacing: 7.w,
                children: [
                  AppText(LocaleKeys.welcome, fontSize: 12.sp),
                  AppText(
                    UserCubit.instance.user.name ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ],
              ),
              const PromotionShowingHandler(),
            ],
          ),
          const Spacer(),
          const FilterButton(),
        ],
      ),
    );
  }
}

class PromotionShowingHandler extends StatelessWidget {
  const PromotionShowingHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPromoted = context.select(
      (UserCubit cubit) => cubit.user.isPromoted,
    );
    final PromotionBadgeDataModel promotionBadge =
        context.watch<PromotionBadgeCubit>().state.data;

    if (isPromoted) {
      return PromotedBadge(data: promotionBadge);
    }

    return PromotionBadge(data: promotionBadge);
  }
}
