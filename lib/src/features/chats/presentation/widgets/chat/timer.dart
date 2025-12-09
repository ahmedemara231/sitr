import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_pic.dart';

class ChatTimerWidget extends StatefulWidget {
  final int time;
  final String phaseTitle;
  const ChatTimerWidget({super.key,
    required this.time,
    required this.phaseTitle,
  });

  @override
  State<ChatTimerWidget> createState() => _ChatTimerWidgetState();
}

class _ChatTimerWidgetState extends State<ChatTimerWidget> {

  late final EasyTimerController _timerCont;

  @override
  void initState() {
    _timerCont = EasyTimerController();
    super.initState();
  }

  @override
  void dispose() {
    _timerCont.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
            widget.phaseTitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54
        ),
        EasyTimerCount.builder(
            controller: _timerCont,
            duration: EasyTime(seconds: widget.time),
            builder: (time) => Column(
              spacing: 10.h,
              children: [
                // AppText(LocaleKeys.sufficientKnowledge),
                Row(
                  spacing: 5.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SvgPic(assetName: Assets.svgClock),
                    AppText(time, fontSize: 22.sp, fontWeight: FontWeight.w500),
                  ],
                )
              ],
            ),
            onTimerStarts: (context){},
            onTimerEnds: (context) {}
        ),
      ],
    );
  }
}
