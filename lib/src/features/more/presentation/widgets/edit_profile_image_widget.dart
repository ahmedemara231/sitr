import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/svg_pic.dart';

class EditProfileImageWidget extends StatefulWidget {
  final void Function(File? image) onSelectImage;
  const EditProfileImageWidget({super.key,
    required this.onSelectImage,
  });

  @override
  State<EditProfileImageWidget> createState() => _EditProfileImageWidgetState();
}

class _EditProfileImageWidgetState extends State<EditProfileImageWidget> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50.sp,
          backgroundImage: image.isNotNull?
          FileImage(image!) :
          NetworkImage(UserCubit.instance.user.avatar?? ''),
        ),
        InkWell(
          onTap: () async{
            final selectedImage = await Helpers.getImageFromCameraOrDevice();
            setState(() => image = selectedImage);
            log('the selected image is ${selectedImage}');
            widget.onSelectImage.call(selectedImage);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary
            ),
            child: const SvgPic(
              assetName: Assets.svgCamera,
              color: Colors.white
            ).paddingAll(5.sp),
          ),
        )
      ],
    );
  }
}
