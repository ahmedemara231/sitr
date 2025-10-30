import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../cubits/start_chat.dart';
import '../cubits/upload_image.dart';

class ChatImageViewerWidget extends StatelessWidget {
  final File image;
  final void Function(String url) onUpload;
  const ChatImageViewerWidget({super.key,
    required this.image,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadImageCubit(),
      child: AppScaffold(
        appBarTitle: ConstantManager.emptyText,
        body: Center(child: Image.file(image)),
        bottomBar: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<UploadImageCubit, AsyncState>(
              builder: (context, state) => InkWell(
                onTap: () => context.read<UploadImageCubit>().uploadImage(
                    image: image,
                    roomId: context.read<StartChatCubit>().state.data.room!.id.toString(),
                    onSuccess: (data){
                      onUpload.call(state.data);
                      Go.back();
                    },
                ),
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white,
                  ),
                  child: StatusBuilder(
                    onLoading: () => SizedBox.square(
                      dimension: 30.sp,
                        child: CustomLoading.showLoadingView()),
                    data: state,
                      onSuccess: (data, context) => const SvgPic(
                          assetName: Assets.svgSend,
                          color: AppColors.primary
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
