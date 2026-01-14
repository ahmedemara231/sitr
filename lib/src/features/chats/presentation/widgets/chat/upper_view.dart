import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/num.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/chat_model.dart';
import '../../cubits/start_chat.dart';
import '../chat_report_icon.dart';
import 'timer.dart';

enum UpperWidgetAfterReportIcon {timer, reason}
class ChatUpperWidget extends StatelessWidget {
  final String requestId;
  final UpperWidgetAfterReportIcon _afterReportIcon;
  final String? label;
  final Color? labelBackgroundColor;

  const ChatUpperWidget.withTimer({super.key, required this.requestId}) :
        _afterReportIcon = UpperWidgetAfterReportIcon.timer,
        label = null, labelBackgroundColor = null;

  const ChatUpperWidget.withLabel({super.key,
    required this.requestId,
    required this.label,
    required this.labelBackgroundColor,
  }) :
        _afterReportIcon = UpperWidgetAfterReportIcon.reason;

  Widget _upperWidget(ChatModel model){
    final int? timer = model.matchRequest!.timer;
    if(timer.isNotNull && timer.isNotEqualZero){
      return ChatTimerWidget(
        time: model.matchRequest?.timer ?? 5,
        phaseTitle: model.matchRequest?.stage?.description ??'',
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: ChatReportIcon(id: int.parse(requestId))
        ),
        Align(
          alignment: Alignment.center,
          child: _afterReportIcon == UpperWidgetAfterReportIcon.timer?
          BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
              builder: (context, state) => StatusBuilder(
                  data: state,
                  onFail: () => const SizedBox.shrink(),
                  onSuccess: (data, context) => _upperWidget(data)
              )) :
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: labelBackgroundColor?.withOpacity(.1),
            ),

            child: AppText(label!, color: labelBackgroundColor).paddingSymmetric(
                vertical: 10.h,
                horizontal: 20.w
            ),
          ),
        )
      ],
    );
  }
}
