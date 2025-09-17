import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/image_widgets/upload_image.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/complaint_cubit/complaint_details_cubit.dart';
import '../../models/complaint_details_model.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  const ComplaintDetailsScreen({super.key, required this.complaintId});

  final int complaintId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ComplaintDetailsCubit()..fetchComplaintDetails(complaintId),
      child: Scaffold(
        backgroundColor: AppColors.whiteScaffoldBackground,

        appBar: customAppBar(appBarTitle: LocaleKeys.complaintDetails),
        body: BlocBuilder<ComplaintDetailsCubit,
            AsyncState<ComplaintDetailsModel?>>(
          builder: (context, state) {
            return StatusBuilder(
                data: state,
                onSuccess: (data, context) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          children: List.generate(
                            data?.images.length ?? 0,
                            (index) => (IconWidget(
                              icon: data?.images[index],
                              width: 60.w,
                              height: 60.h,
                            )),
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
                        AppText(
                          data?.complaint ?? '',
                          color: AppColors.textBlack,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ).paddingAll(16.r),
                  );
                });
          },
        ),
      ),
    );
  }
}

