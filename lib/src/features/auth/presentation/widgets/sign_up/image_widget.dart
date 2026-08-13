import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/widgets/icon_widget.dart';

class SelectImageWidget extends StatefulWidget {
  final dynamic initialValue;
  final void Function(File? image) onSelectImage;

  const SelectImageWidget({
    super.key,
    required this.onSelectImage,
    this.initialValue,
  });

  @override
  State<SelectImageWidget> createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<SelectImageWidget> {
  File? _selectedImage;

  ImageProvider<Object>? get _imageProvider {
    final dynamic image = _selectedImage ?? widget.initialValue;
    if (image is File) {
      return FileImage(image);
    }
    if (image is String && image.isNotEmpty) {
      return NetworkImage(image);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.whiteGreyColor,
            backgroundImage: _imageProvider,
            child: _imageProvider == null
                ? IconWidget(
                    icon: Assets.assets.svg.user.path,
                    color: AppColors.primary,
                    height: 36.r,
                    width: 36.r,
                  )
                : null,
          ).paddingAll(3.r),
        ),
        InkWell(
          onTap: () async {
            final File? selectedImage =
                await Helpers.getImageFromCameraOrDevice();
            if (selectedImage.isNotNull) {
              setState(() => _selectedImage = selectedImage);
              widget.onSelectImage.call(selectedImage);
            }
          },
          child: Container(
            padding: EdgeInsets.all(7.r),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconWidget(
              icon: Assets.assets.svg.camera.path,
              color: AppColors.white,
              height: 18.r,
              width: 18.r,
            ),
          ),
        ),
      ],
    );
  }
}
