import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as Go;
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/form_field_validation.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/image_widgets/upload_image.dart';
import '../../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/complaint_cubit/add_complaint_cubit.dart';

class AddComplaintAndSuggestion extends StatefulWidget {
  const AddComplaintAndSuggestion({super.key});

  @override
  State<AddComplaintAndSuggestion> createState() =>
      _AddComplaintAndSuggestionState();
}

class _AddComplaintAndSuggestionState extends State<AddComplaintAndSuggestion> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  List<File> file = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddComplaintCubit(),
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: AppColors.whiteScaffoldBackground,

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
                  onUpload:(files){
                    file=files;
                  } ,
                  uploadImageType: UploadImageType.multi,
                  tappedItem: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteGreyColorProMax,
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          LocaleKeys.pleaseAttachImages,
                          color: AppColors.grey,
                          fontSize: 12.sp,
                        ),
                        const IconWidget(icon: Assets.svgCamera),
                      ],
                    ),
                  ),
                ).asFormField(validator: (val) {
                  return file.isEmpty
                      ? LocaleKeys.fillField.tr(context:context)
                      : null;
                }),
                17.szH,
                AppText(
                  LocaleKeys.complaintText,
                  color: AppColors.textBlack,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
                8.szH,
                DefaultTextField(
                  controller: controller,
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
          bottomNavigationBar: BlocConsumer<AddComplaintCubit, AsyncState>(
            listener: (context, state) {
              if(state.isSuccess){
                showDefaultBottomSheet(
                    child: SuccessSheet(
                      isInAuth: false,
                      upperText: AppText(
                        LocaleKeys.theComplaintDataHasBeenSuccessfullySentToManagement,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                );
              }
            },
            builder: (context, state) {
              return AppLoadingButton(
                  asyncCall: (context) async {
                    if(formKey.currentState!.validate()){
                      await context
                          .read<AddComplaintCubit>()
                          .addComplaint(title: controller.text, file: file);
                    }

                  },
                  title: LocaleKeys.send);
            },
          ).paddingAll(16.r),
        ),
      ),
    );
  }
}
