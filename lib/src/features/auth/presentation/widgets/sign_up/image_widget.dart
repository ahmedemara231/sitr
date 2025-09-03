import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/helpers/helpers.dart';
import '../shared/text_field.dart';

class SignUpImageWidget extends StatelessWidget {
  final void Function(File? image) onSelectImage;
  SignUpImageWidget({super.key,
    required this.onSelectImage,
  });

  ValueNotifier<File?> image = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignUpTextField(
          readOnly: true,
          onTap: () async{
            final selectedImage = await Helpers.getImageFromCameraOrDevice();
            image.value = selectedImage;
            onSelectImage.call(selectedImage);
          },
          upperTitle: LocaleKeys.profilePicture,
          title: LocaleKeys.pleaseEnterYourProfilePicture,
          suffixIconPath: Assets.svgCamera,
          controller: TextEditingController(),
          // validator: Validators.validateEmpty,
        ),
        ValueListenableBuilder(
            valueListenable: image,
            builder: (context, value, child) => value.isNotNull? CircleAvatar(
              radius: 50.sp,
              backgroundImage: FileImage(value!),
            ) : const SizedBox.shrink()
        ),
      ],
    );
  }
}
