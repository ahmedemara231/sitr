import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../home/home_screen.dart';
import '../../cubits/finish_chat_cubit.dart';

class CongratsSheet extends StatelessWidget {
  final int matchReqId;
  const CongratsSheet({super.key, required this.matchReqId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => FinishChatCubit()..finishChat(matchReqId),
      child: Column(
        spacing: 10.h,
        children: [
          Image.asset(Assets.imagesMarriageBalloons),
          AppText(LocaleKeys.congratulationsOnYourEngagementWeAskGodToBlessYourUnionAndGrantYouHappiness),
          AppDefaultButton.withBackGroundColor(
              title: LocaleKeys.back,
              onTap: () {
                Go.back();
              }
          )
        ],
      ),
    );
  }
}

class RejectedChatSheet extends StatelessWidget {
  const RejectedChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        Image.asset(Assets.imagesAlert),
        AppText(LocaleKeys.rejected, fontWeight: FontWeight.bold),
        AppText(LocaleKeys.unableToContinueChattingRightNow),
        AppDefaultButton.withBackGroundColor(
          title: LocaleKeys.back,
          onTap: () {
            Go.offAll(const HomeScreen());
          },
        )
      ],
    );
  }
}

class ParentIndividualCongratsSheet extends StatelessWidget {
  final int matchReqId;
  final void Function()? onTap;
  const ParentIndividualCongratsSheet({super.key, required this.matchReqId, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        Image.asset(Assets.imagesMarriageBalloons),
        AppText(LocaleKeys.congratulationsTheParentApprovedYouYouCanSeeHisChildrenFromNow),
        AppDefaultButton.withBackGroundColor(
            title: LocaleKeys.showParentChildren,
            onTap: () {
              onTap?.call();
            }
        )
      ],
    );
  }
}
