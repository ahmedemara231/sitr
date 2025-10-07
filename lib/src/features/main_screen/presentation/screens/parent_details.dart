import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../cubits/get_parent_info_cubit.dart';
import '../widgets/partner_info/partner_app_bar_icons.dart';

class ParentDetailsScreen extends StatelessWidget {
  const ParentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold.withCenteredCard(
        upperWidget: BlocBuilder<GetParentInfoCubit, AsyncState>(
          builder: (context, state) => Stack(
            alignment: Alignment.topCenter,
            children: [
              StatusBuilder(
                data: state,
                onSuccess: (data, context) => CachedImage(
                    height: 200.h,
                    url: state.data.avatar ?? '', fit: BoxFit.fill
                ),
              ),
              Container(
                width: context.width,
                height: 200.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black38, Colors.black26])
                ),
              ),
              Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const PartnerAppBarIcons(
                          icon: Icon(Icons.flag, color: Colors.white)
                      )
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: PartnerAppBarIcons(
                          icon: const SvgPic(
                              assetName: Assets.svgBlockUser,
                              color: Colors.white
                          ).paddingAll(10)
                      )
                  ),
                ],
              ).paddingSymmetric(horizontal: 10.w),
            ],
          ),
        ),
        body: Container(),
        centerCardBody: Container()
    );
  }
}
