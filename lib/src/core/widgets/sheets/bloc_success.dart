import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/more/presentation/cubit/block_user_cubit/un_block_user_cubit.dart';
import '../../extensions/num.dart';
import '../../navigation/navigator.dart';
import '../../shared/block_user_cubit.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';
import '../svg_pic.dart';

enum BlocManager {block, unblock}
class BlocManagerSheet extends StatelessWidget {
  final BlocManager blocManager;
  final int id;
  const BlocManagerSheet({super.key,
    required this.id,
    required this.blocManager,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BlockUserCubit()),
        BlocProvider(create: (context) => UnBlockUserCubit()),
      ],
      child: AppBottomSheet.large(
          asyncCall: (context) => blocManager == BlocManager.unblock?
          context.read<UnBlockUserCubit>().unblockUser(userId: id) :
          context.read<BlockUserCubit>().block(id),
          btnTitle: LocaleKeys.confirm,
          cancelBackgroundColor: AppColors.pink,
          upperWidget: Column(
            spacing: 30.h,
            children: [
              const SvgPic(assetName: Assets.svgForbidden),

              if(blocManager == BlocManager.unblock)
                AppText(LocaleKeys.areYouSureYouWantToUnblock, fontSize: 18.sp,)
              else
                AppText(LocaleKeys.areYouSureToBlockThisUser, fontSize: 18.sp,)
            ],
          )
      ),
    );
  }
}
