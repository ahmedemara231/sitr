import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';

class ChatBottomBar extends StatefulWidget {
  final FutureOr<void> Function(BuildContext context) onSend;
  const ChatBottomBar({super.key,
    required this.onSend
  });

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  late final TextEditingController _chatCont;

  @override
  void initState() {
    _chatCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _chatCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.h,
      child: Container(
        color: AppColors.whiteGreyColor,
        padding: EdgeInsets.all(16.r),
        child: Row(
          spacing: 10.w,
          children: [
            InkWell(
              onTap: () {
                _chatCont.clear();
                widget.onSend.call(context);
              },
              child: Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                ),
                child: const SvgPic(assetName: Assets.svgSend, color: AppColors.primary),
              ),
            ),
            Expanded(
              child: DefaultTextField(
                controller: _chatCont,
                title: LocaleKeys.hereIsTheTextOfTheMessageHereIsTheTextOfTheMessageHereIsTheTextOfTheMessage,
                prefixIcon: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.camera_alt_sharp)
                ),
              ),
            )
          ],
        ),
      ),
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }
}
