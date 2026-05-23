import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/widgets/svg_pic.dart';
class SelectImageWidget extends StatelessWidget {
  final String? initialValue;
  final void Function(File? image) onSelectImage;
  SelectImageWidget({super.key,
    required this.onSelectImage,
    this.initialValue,
  });

  final ValueNotifier<File?> image = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: image,
            builder: (context, value, child) => Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    shape: BoxShape.circle
                  ),
                  child: CircleAvatar(
                    radius: 50.sp,
                    backgroundImage: value.isNotNull? FileImage(value!) :
                    NetworkImage(initialValue ?? ConstantManager.defaultAvatar),
                  ).paddingAll(3.r),
                ),
                InkWell(
                  onTap: () async{
                    final selectedImage = await Helpers.getImageFromCameraOrDevice();
                    if(selectedImage.isNotNull){
                      image.value = selectedImage;
                      onSelectImage.call(selectedImage);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle
                      ),
                      child: SizedBox.square(
                          dimension: 20.sp,
                          child: const SvgPic(assetName: Assets.svgCamera, color: Colors.white)
                      )
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}
