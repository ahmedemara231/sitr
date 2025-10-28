import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../chat_image_viewer.dart';

class ChatBottomBar extends StatefulWidget {
  final FutureOr<void> Function(BuildContext context, String message) onSend;
  final void Function(String url) onUpload;
  const ChatBottomBar({
    super.key,
    required this.onSend,
    required this.onUpload
  });

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  late final TextEditingController _chatCont;
  final ValueNotifier<File?> _selectedImage = ValueNotifier(null);

  @override
  void initState() {
    _chatCont = TextEditingController();
    super.initState();
  }

  bool makeConditionToNull(bool Function() condition){
    if(condition.call()){
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _chatCont.dispose();
    super.dispose();
  }

  void _selectedImageListener() => _selectedImage.value.isNotNull?
  Go.to(ChatImageViewerWidget(
    image: _selectedImage.value,
    onUpload: widget.onUpload,
  )) : null;

  void _addListener() => _selectedImage.addListener(_selectedImageListener);
  @override
  Widget build(BuildContext context) {
    _addListener();
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ValueListenableBuilder(
          //     valueListenable: _selectedImage,
          //     builder: (context, file, child) => file.isNotNull?
          //         SizedBox.square(
          //             dimension: 100.sp,
          //             child: Image.file(file!)
          //         ) : const SizedBox.shrink()
          // ).paddingAll(10.r),
          SizedBox(
            height: 75.h,
            child: Container(
              color: AppColors.whiteGreyColor,
              padding: EdgeInsets.all(16.r),
              child: Row(
                spacing: 10.w,
                children: [
                  InkWell(
                    onTap: _chatCont.text.isEmpty && _selectedImage.value.isNull ? null : () {
                      widget.onSend.call(context, _chatCont.text);

                      _chatCont.clear();
                      _selectedImage.value = null;
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
                          onPressed: () async{
                            final result = await Helpers.getImageFromCameraOrDevice();
                            _selectedImage.value = result;
                          },
                          icon: const Icon(Icons.camera_alt_sharp, color: AppColors.primary)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ).paddingBottom(MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}


