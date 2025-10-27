import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../features/chats/presentation/cubits/get_tips_cubit.dart';
import '../../../features/chats/presentation/screens/chat_screen.dart';
import '../../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../extensions/padding_extension.dart';
import '../../helpers/helpers.dart';
import '../../helpers/status_builder.dart';
import '../../helpers/user_type_enum.dart';
import '../../navigation/navigator.dart';
import '../../network/api_endpoints.dart';
import '../../shared/models/user_models/user_model.dart';
import '../app_text.dart';
import '../buttons/custom_app_buttons/default_button.dart';
import '../default_bottom_sheet.dart';

enum ChatButtonActions { startChat, viewTips, none}
class ChatButton extends StatelessWidget {
  final UserModel user;
  ChatButton({super.key, required this.user});

  late final Map<ChatButtonActions, FutureOr<void> Function()?> _chatButtonPossibleActions = {
    ChatButtonActions.startChat : () {
      Go.to(ChatScreen(
      receiverId: user.id ?? 0,
      fromHome: 1,
    ));
    },

    ChatButtonActions.viewTips : () => user.gender!.userType!.isParent?
    showDefaultBottomSheet(
        child: TipsSheet(
            title: LocaleKeys.tipsForTheStageOfSufficientKnowledge,
            path: ApiConstants.parentIndividualConversation,
            onConfirm: (context) => _chatButtonPossibleActions[ChatButtonActions.startChat]?.call()
        )
    ) :
    showDefaultBottomSheet(
        child: TipsSheet(
          title: LocaleKeys.clarification,
          path: ApiConstants.appStages,
          onConfirm: (context) => showDefaultBottomSheet(
              child: TipsSheet(
                  title: LocaleKeys.tipsForTheStageOfSufficientKnowledge,
                  path: ApiConstants.chattingStageTips,
                  onConfirm: (context) => _chatButtonPossibleActions[ChatButtonActions.startChat]?.call()
              )
          ),
        )
    ),

    ChatButtonActions.none : null,
  };

  ChatButtonActions get _getButtonAction{
    if(user.canChat!){
      if(!user.hasChatWith!){
        return ChatButtonActions.viewTips;
      }else{
        return ChatButtonActions.startChat;
      }
    }else{
      return ChatButtonActions.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDefaultButton.withBackGroundColor(
      onTap: _chatButtonPossibleActions[_getButtonAction],
      borderColor: Colors.grey[300],
      backgroundColor: user.canChat!? null : Colors.grey[300],
      title: LocaleKeys.startChat,
    );
  }
}

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
                        (i) => AppText(tips[i]).paddingSymmetric(vertical: 10.h)
                ),
              ),
              AppDefaultButton.withBackGroundColor(
                title: LocaleKeys.confirm,
                onTap: () => onConfirm.call(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}