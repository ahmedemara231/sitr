import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart' show Assets;
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/parent_children.dart';
import '../../../../core/widgets/parent_children_screen.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import '../../../main_screen/data/models/partner_info_model.dart';
import '../../../main_screen/presentation/widgets/partner_info/info_widget.dart';
import '../cubit/get_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late List<PartnerInfoModel> partnerInfo = [];
    return UserModel.isParent?
    BlocProvider(
      create: (context) => GetProfileCubit()..getUserModelData(
          onSuccess: (user){
            partnerInfo = [
              PartnerInfoModel(leading: Assets.svgMartialStatus, title: LocaleKeys.kinship, subTitle: (user as ParentModel).relation?.value),
              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenNumber, subTitle: user.numOfChildren.toString()),
              PartnerInfoModel(leading: Assets.svgProfilePhone, title: LocaleKeys.phoneNumber, subTitle: user.phone),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.gender, subTitle: user.gender?.titleValueShape?.title),
            ];
          }
      ),
      child: BlocBuilder<GetProfileCubit, AsyncState<UserModel>>(
        builder: (context, state) => CenterCardScaffold.withCenteredCard(
            upperWidget: Stack(
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
              ],
            ),
            cardTopPadding: 150.h,
            centerCardBody: StatusBuilder(
              data: state,
              onSuccess: (data, context) => Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r)
                ),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: AppText(
                        data.name ?? '',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold
                    ).paddingSymmetric(horizontal: 12.w)
                ),
              ),
            ),
            body: Column(
              spacing: 10.h,
              children: [
                StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 2.5,
                    children: List.generate(
                        partnerInfo.length,
                            (i) => InkWell(
                                onTap: i == 1?
                                    () => Go.to(ParentChildrenView(id: state.data.id ?? 0))
                                    : null,
                                child: InfoWidget(partnerInfoModel: partnerInfo[i])
                            )
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    ) :
    ViewProfileWidget.profile(cubit: GetProfileCubit());
  }
}
