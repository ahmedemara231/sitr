import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/more/presentation/cubit/block_user_cubit/un_block_user_cubit.dart';
import '../../navigation/navigator.dart';
import '../../shared/block_user_cubit.dart';
import '../app_bottom_sheet.dart';
import '../app_text.dart';
import '../custom_messages.dart';
import '../svg_pic.dart';

enum BlocManager {block, unblock}
class BlocManagerSheet extends StatelessWidget {
  final BlocManager blocManager;
  final int id;
  final void Function() onPress;
  const BlocManagerSheet({super.key,
    required this.id,
    required this.blocManager,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BlockUserCubit()),
        BlocProvider(create: (context) => UnBlockUserCubit()),
      ],
      child: AppBottomSheet.large(
          asyncCall: (context) async{
            if(blocManager == BlocManager.unblock){
              await context.read<UnBlockUserCubit>().unblockUser(
                userId: id,
                onSuccess: (msg){
                  MessageUtils.showSnackBar(msg);
                }
              );

            }else{
              await context.read<BlockUserCubit>().block(
                  id: id,
                  onSuccess: (msg){
                    MessageUtils.showSnackBar(msg);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Go.offAll(const HomeScreen());
                    });
                  }
              );
            }

            onPress.call();
          },
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
