import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/chats/presentation/screens/chat_screen.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../network/api_endpoints.dart';
import '../shared/models/user_models/user_model.dart';
import 'buttons/custom_app_buttons/default_button.dart' show AppDefaultButton;
import 'default_bottom_sheet.dart';
import 'sheets/tips_sheet.dart';

enum ChatButtonActions { startChat, viewTips, none}
class ChatButton extends StatelessWidget {
  final UserModel user;
  ChatButton({super.key, required this.user});


  late final Map<ChatButtonActions, FutureOr<void> Function()?> _chatButtonPossibleActions = {
    ChatButtonActions.startChat : () {
      Go.to(ChatScreen(
        receiverId: user.id ?? 0,
        receiverName: user.name ?? '',
        fromHome: 1,
      ));
    },

    ChatButtonActions.viewTips : () => user.gender!.userType!.isParent?
    showDefaultBottomSheet(
        child: TipsSheet(
            title: LocaleKeys.tipsForTheStageOfSufficientKnowledge,
            path: ApiConstants.parentIndividualConversation,
            btnTitle: LocaleKeys.start,
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
                  btnTitle: LocaleKeys.start,
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