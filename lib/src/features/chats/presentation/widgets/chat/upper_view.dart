import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/num.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../../home/home_screen.dart';
import '../../../data/chat_actions/imports.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/request_model.dart';
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
  }) : _afterReportIcon = UpperWidgetAfterReportIcon.reason;

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
            alignment: Languages.currentIsArabic?
            Alignment.topRight : Alignment.topLeft,
            child: ChatReportIcon(id: int.parse(requestId))),
        if(_afterReportIcon == UpperWidgetAfterReportIcon.timer)
          ...[
            Center(
              child: BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
                  builder: (context, state) => StatusBuilder(
                      data: state,
                      onFail: () => const SizedBox.shrink(),
                      onSuccess: (data, context) => _upperWidget(data)
                  )),
            ),
            Align(
              alignment: Languages.currentIsArabic?
              Alignment.topLeft : Alignment.topRight,
              child: BlocBuilder<ChatCubit, AsyncState<ChatModel>>(
                builder: (context, state) => InkWell(
                  onTap: () => WidgetsBinding.instance.addPostFrameCallback(
                          (_) => showDefaultBottomSheet(
                          child: AppBottomSheet.large(
                            asyncCall: (ctx) async{
                              await ChatActions.executeReq(
                                context: context,
                                requestModel: RequestModel(
                                    receiverId: state.data.room!.members!.first.id.toString(),
                                    fromHome: 1.toString()
                                ),
                                path: ApiConstants.forceReject,
                                onSuccess: (chatModel){
                                  Go.offAll(const HomeScreen());
                                },
                              );
                            },
                            btnTitle: LocaleKeys.endChat,
                            upperWidget: Column(
                              spacing: 10.h,
                              children: [
                                Image.asset(Assets.imagesAlert),
                                AppText(LocaleKeys.areYouSureToEndChat),
                              ],
                            ),
                            cancelBackgroundColor: Colors.red.withOpacity(.4),
                          )
                      )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      SvgPic(assetName: Assets.svgEndChatIcon, size: 20.sp,),
                      AppText(
                        LocaleKeys.endChat,
                        color: AppColors.redColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]
        else
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: labelBackgroundColor?.withOpacity(.1),
              ),

              child: AppText(label!, color: labelBackgroundColor).paddingSymmetric(
                  vertical: 10.h,
                  horizontal: 20.w
              ),
            ),
          ),
      ],
    );
  }
}
