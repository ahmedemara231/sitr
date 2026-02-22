import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/models/request_model.dart';
import '../cubits/get_chats_cubit.dart';
import '../widgets/chat/chat_view.dart';
import '../widgets/chat/upper_view.dart';

class PreviousChatScreen extends StatelessWidget {
  final ChatType chatType;
  final RequestModel requestModel;

  const PreviousChatScreen({
    super.key,
    required this.chatType,
    required this.requestModel,
  });

  String get _label {
    switch (chatType) {
      case ChatType.completed:
        return LocaleKeys.completed;
      case ChatType.rejected:
        return LocaleKeys.refused;
      case ChatType.cancelled:
        return LocaleKeys.cancelled;
      case ChatType.pending:
        return LocaleKeys.pending;
      default:
        return '';
    }
  }

  Color get _labelBackgroundColor {
    switch (chatType) {
      case ChatType.completed:
      case ChatType.pending:
        return Colors.green;
      case ChatType.rejected:
      case ChatType.cancelled:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: LocaleKeys.chat,
      body: Column(
        spacing: 10.h,
        children: [
          ChatUpperWidget.withLabel(
            requestId: requestModel.receiverId,
            label: _label,
            labelBackgroundColor: _labelBackgroundColor,
          ),
          SizedBox(
            height: context.height - 170,
            child: ChatView(
              requestModel: requestModel,
              chatController: PagifyController(),
            ),
          ),
        ],
      ),
    );
  }
}
