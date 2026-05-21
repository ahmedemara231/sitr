import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../cubit/complaint_cubit/complaint_details_cubit.dart';
import '../../models/complaint_details_model.dart';
import 'image_view.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  const ComplaintDetailsScreen({super.key, required this.complaintId});

  final int complaintId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ComplaintDetailsCubit()..fetchComplaintDetails(complaintId),
      child: AppScaffold(
        appBarTitle: LocaleKeys.complaintDetails,
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 10.w,
                            children: List.generate(
                              data?.images.length ?? 0,
                                  (index) =>
                                     InkWell(
                                       onTap: () => Go.to(ImageViewScreen(url: data?.images[index].image ?? '')),
                                       child: CachedImage(
                                           height: 70,
                                           width: 70,
                                           borderRadius: BorderRadius.circular(10.r),
                                           url: data?.images[index].image ?? ''
                                       ),
                                     ),

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
                        AppText(
                          data?.complaint ?? '',
                          color: AppColors.textBlack,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),

                        12.szH,
                        if(data!.adminReply.isNotNull && data.adminReply!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(LocaleKeys.adminReply),
                              AppText(
                                data.adminReply ?? '',
                                color: AppColors.textBlack,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
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

