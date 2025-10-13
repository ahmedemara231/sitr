import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../cubit/change_notify_cubit.dart';
import '../screens/more_screen.dart';
import '../widgets/custom_icon_inside_container.dart';

class MoreItem extends StatelessWidget {
  const MoreItem({
    super.key,
    required this.moreItemModel,
  });

  final MorItemModel moreItemModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moreItemModel.onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Row(
            children: [
               CustomIconInsideContainer(
                icon: moreItemModel.icon,
                backgroundColor: AppColors.offWhite,
              ),
              10.szW,
              AppText(
                moreItemModel.label,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const Spacer(),
              SizedBox.square(
                  dimension: 16,
                  child: moreItemModel.withSwitch? BlocProvider(
                    create: (context) => ChangeNotifyCubit(),
                    child: BlocBuilder<ChangeNotifyCubit, AsyncState<bool>>(
                     // builder: (context, state) => Switch(
                     //     value: state.data,
                     //     onChanged: (val) => context.read<ChangeNotifyCubit>().changeNotify()
                     // ),
                      builder: (context, state) => StatusBuilder(
                          data: state,
                          onSuccess: (data, context) => Switch(
                              value: data,
                              onChanged: (val) => context.read<ChangeNotifyCubit>().changeNotify()
                          ),
                      )
                    ),
                  ) :
                  const IconWidget(icon: Assets.svgArrowLeftIcon)
              )
            ],
          )),
    );
  }
}
