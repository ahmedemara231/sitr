import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/image_widgets/upload_image.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';

class AddComplaintAndSuggestion extends StatelessWidget {
  const AddComplaintAndSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appBarTitle: LocaleKeys.complaintDetails),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              LocaleKeys.complaintImages,
              color: AppColors.textBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            8.szH,
            UploadImageWidget(
              uploadImageType: UploadImageType.multi,
              tappedItem: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteGreyColorProMax,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      LocaleKeys.pleaseAttachImages,
                      color: AppColors.textBlack,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    const IconWidget(icon: Assets.svgCamera),
                  ],
                ),
              ),
            ),
            17.szH,
            AppText(
              LocaleKeys.complaintText,
              color: AppColors.textBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            8.szH,
            DefaultTextField(
              title: LocaleKeys.pleaseAttachText,
              fillColor: AppColors.whiteGreyColorProMax,
              borderColor: Colors.transparent,
              maxLines: 9,
              inputType: TextInputType.multiline,
              validator: (value) => Validators.validateEmpty(value),
            ),
          ],
        ).paddingAll(16.r),
      ),
      bottomNavigationBar: AppLoadingButton(
              asyncCall: (context) async {}, title: LocaleKeys.send)
          .paddingAll(16.r),
    );
  }
}
