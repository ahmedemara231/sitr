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

class ComplaintDetailsScreen extends StatelessWidget {
  const ComplaintDetailsScreen({super.key});

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
            Wrap(
              spacing: 6.0.w,
              runSpacing: 8.0.h,
              children:List.generate(10,  (index) => (IconWidget(
                icon: Assets.imagesAttachComplaintImage,
                width: 60.w,
                height: 60.h,
              )),),
            ),
                    17.szH,
            AppText(
              LocaleKeys.complaintText,
              color: AppColors.textBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            8.szH,
            AppText(
              text,
              color: AppColors.textBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ).paddingAll(16.r),
      ),

    );
  }
}
 String text='هذا النص افتراضي هذا النص يمكن استبداله بنص أخر في  المساهذا النص افتراضي يمكن استبداله هذا النص افتراضي هذا النص افتراضي هذا النص يمكن استبداله بنص أخر في نفس المساحة هذا النص افتراضي يمكن استبداله هذا النص افتراضي';