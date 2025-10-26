import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../config/res/config_imports.dart';
import '../../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../../core/widgets/icon_widget.dart';
import '../../../../../../core/widgets/sheets/bloc_success.dart';
import '../../../cubit/block_user_cubit/un_block_user_cubit.dart';
import '../../../models/block_user_model.dart';

class BlockedUserItem extends StatelessWidget {
  const BlockedUserItem({
    super.key, required this.blockUserModel, required this.function,
  });

  final BlockUserModel blockUserModel;
  final dynamic Function(dynamic) function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          top: 10.h, bottom: 10.h, start: 16.w, end: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: Colors.white),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: IconWidget(
                icon: blockUserModel.avatar ?? '',
                width: 60,
                height: 60,
              )),
          15.szW,
          AppText(blockUserModel.name ?? '',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black),
          const Spacer(),
          BlocProvider(
            create: (context) => UnBlockUserCubit(),
            child: BlocBuilder<UnBlockUserCubit, AsyncState>(
              builder: (context, state) {
                return state.isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary,)
                    : DefaultButton(
                  onTap: () async {
                    showDefaultBottomSheet(
                      child: BlocManagerSheet(
                          id: blockUserModel.id ?? 0,
                          blocManager: BlocManager.unblock
                      )
                    );
                  },
                  width: 83.w,
                  height: 22.h,
                  borderRadius: BorderRadius.circular(11),
                  title: LocaleKeys.unblock,
                  textColor: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.redColor,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
