import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/presentation/cubits/check_chat_eligibility_cubit.dart';
import '../../features/chats/presentation/imports.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/user_model.dart';
import 'buttons/app_loading_button.dart';

class ChatButton extends StatelessWidget {
  final UserModel user;
  const ChatButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckChatEligibilityCubit(),
      child: BlocBuilder<CheckChatEligibilityCubit, AsyncState<bool>>(
        builder: (context, state) => AppLoadingButton(
          asyncCall: (context) => Go.to(ChatScreen(
            requestModel: RequestModel(
              receiverId: '${user.id}',
              fromHome: 1.toString(),
            ),
            receiverName: user.name ?? '',
          )),
          // asyncCall: (context) => (user.canChat!) ?
          //     context.read<CheckChatEligibilityCubit>().checkEligibility(
          //           requestModel: RequestModel(
          //               receiverId: user.id.toString(),
          //               fromHome: 1.toString()
          //           ),
          //           onEligible: () => Go.to(ChatScreen(
          //             requestModel: RequestModel(
          //               receiverId: '${user.id}',
          //               fromHome: 1.toString(),
          //             ),
          //             receiverName: user.name ?? '',
          //           )),
          //     ) : Future(() => null),
          buttonColor: user.canChat??false ? null : Colors.grey[300],
          title: LocaleKeys.startChat,
        ),
      ),
    );
  }
}