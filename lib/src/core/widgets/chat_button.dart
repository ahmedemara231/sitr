import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/language/locale_keys.g.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/presentation/cubits/check_chat_eligibility_cubit.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import 'buttons/app_loading_button.dart';
import 'custom_messages.dart';

class ChatButton extends StatelessWidget {
  final UserModel user;

  const ChatButton({super.key, required this.user});

  CanChat get _initialCanChat => user.canChat ?? CanChat.initial();

  RequestModel get _requestModel => RequestModel(
        receiverId: user.id.toString(),
        fromHome: 1.toString(),
      );

  String _buttonTitle(CanChat canChat) {
    return canChat.canChat
        ? LocaleKeys.sendChatRequest
        : canChat.reason.getReason;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckChatEligibilityCubit(
        initialCanChat: _initialCanChat,
      ),
      child: BlocBuilder<CheckChatEligibilityCubit, AsyncState<CanChat>>(
        builder: (context, state) {
          final CanChat canChat = state.data;
          return AppLoadingButton(
            asyncCall: (context) async {
              await context.read<CheckChatEligibilityCubit>().checkEligibility(
                    requestModel: _requestModel,
                    onRequestSent: () => MessageUtils.showSnackBar(
                      LocaleKeys.aChatRequestWasSuccessfullySent,
                    ),
                  );
            },
            buttonColor: canChat.canChat ? null : Colors.grey[300],
            enabled: canChat.canChat,
            title: _buttonTitle(canChat),
          );
        },
      ),
    );
  }
}
