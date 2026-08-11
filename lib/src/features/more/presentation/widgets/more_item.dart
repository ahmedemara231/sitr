import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/permission_handler/handler.dart';
import '../../../../core/helpers/permission_handler/model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_messages.dart';
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
                  child: moreItemModel.withSwitch?
                  const _SwitchIcon() :
                  IconWidget(icon: Assets.assets.svg.arrowLeftIcon.path)
              )
            ],
          )),
    );
  }
}

class _SwitchIcon extends StatelessWidget {
  const _SwitchIcon();

  void _checkNotificationPermission(BuildContext context){
    PermissionHandler().checkPermission(
        permissionManagerModel: PermissionModel(
            permissions: [Permission.notification],
            onGranted: (p) async => await context.read<ChangeNotifyCubit>().changeNotify(),
            onDenied: (p) => MessageUtils.show(
              LocaleKeys.canNotOpenNotificationsEnableFromSetting,
              state: MsgState.info,
            ),
            onDeniedForever: (p) => MessageUtils.show(
              LocaleKeys.canNotOpenNotificationsEnableFromSetting,
              state: MsgState.info,
            ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeNotifyCubit(),
      child: BlocConsumer<ChangeNotifyCubit, AsyncState<bool>>(
        listener: (context, state) {
          if(state.isError){
            context.read<ChangeNotifyCubit>().changeNotifyLocally();
          }
        },
          builder: (context, state) => Switch(
                activeThumbColor: AppColors.primary,
                value: state.data,
                onChanged: (val) {
                  context.read<ChangeNotifyCubit>().changeNotifyLocally();
                  _checkNotificationPermission(context);
                }
            ),
      ),
    );
  }
}
