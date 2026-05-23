import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import 'package:safe_text/safe_text.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/chat_builder/chat_message.dart';
import '../../../../../core/widgets/custom_messages.dart' show MessageUtils;
import '../../../../../core/widgets/svg_pic.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubits/start_chat.dart';
import '../chat_image_viewer.dart';

class ChatBottomBar extends StatefulWidget {
  final FutureOr<void> Function(BuildContext context, String message) onSend;
  final void Function(String url) onUpload;
  final PagifyController<ChatMessages> controller;
  const ChatBottomBar({
    super.key,
    required this.onSend,
    required this.onUpload,
    required this.controller,
  });

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  late final TextEditingController _chatCont;
  final ValueNotifier<File?> _selectedImage = ValueNotifier(null);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _imagesLength = 0;
  void _calcImagesLength(){
    for(ChatMessages msg in widget.controller.items){
      if(msg.message.type == 'image' && msg.sender.isFromMe){
        _imagesLength++;
      }
    }
  }

  @override
  void initState() {
    _addListener();
    _chatCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _chatCont.dispose();
    super.dispose();
  }

  void _selectedImageListener() => _selectedImage.value.isNotNull?
  Go.to(BlocProvider.value(
    value: context.read<ChatCubit>(),
    child: ChatImageViewerWidget(
      image: _selectedImage.value!,
      onUpload: widget.onUpload,
    ),
  )) : null;

  void _addListener() => _selectedImage.addListener(_selectedImageListener);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.whiteGreyColor,
        padding: EdgeInsets.all(16.r),
        child: Row(
          spacing: 10.w,
          children: [
            InkWell(
              onTap: () async{
                if(_chatCont.text.isEmpty){
                  return;

                } else if(_formKey.currentState!.validate()){
                  final bool hasBadWord = await SafeTextFilter.containsBadWord(text: _chatCont.text);
                  if (hasBadWord) {
                    _chatCont.text = SafeTextFilter.filterText(
                      text: _chatCont.text,
                      // هنستخدم partial عشان يبان إن في كلمة اتحذفت زي f**k
                      // أو تستخدم custom لو عايز تكتب مكانها [مخالف]
                      strategy: MaskStrategy.custom(replacement: '[${LocaleKeys.dissenter}]'),
                    );

                    MessageUtils.showTopMsg(LocaleKeys.yourMessageHasBeenHiddenBecauseItContainedInappropriateLanguage);
                    widget.onSend.call(context, _chatCont.text);
                    _chatCont.clear();
                  }else{
                    widget.onSend.call(context, _chatCont.text);
                    _chatCont.clear();
                  }
                  _selectedImage.value = null;
                }
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
              child: Form(
                key: _formKey,
                child: DefaultTextField(
                  closeWhenTapOutSide: false,
                  validator: Validators.validateChatMessage,
                  controller: _chatCont,
                  inputType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  action: TextInputAction.newline,
                  title: LocaleKeys.hereIsTheTextOfTheMessageHereIsTheTextOfTheMessageHereIsTheTextOfTheMessage,
                  prefixIcon: IconButton(
                      onPressed: () async{
                        _calcImagesLength();
                        if(_imagesLength < 2){
                          final result = await Helpers.getImageFromCameraOrDevice();
                          _selectedImage.value = result;

                        }else{
                          MessageUtils.showSnackBar(LocaleKeys.youCanNotSendMoreThan2ImagesInChat);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_sharp, color: AppColors.primary)
                  ),
                ),
              ),
            )
          ],
        ),
      ).paddingBottom(MediaQuery.of(context).viewInsets.bottom),
    );
  }
}

