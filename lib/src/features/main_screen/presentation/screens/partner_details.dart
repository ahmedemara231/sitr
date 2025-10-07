import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../data/models/partner_info_model.dart';
import '../cubits/get_partner_info_cubit.dart';
import '../widgets/partner_info/info_widget.dart';

class PartnerDetails extends StatelessWidget {
  final int id;
  const PartnerDetails({super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    late List<PartnerInfoModel> partnerInfo = [];
    return BlocProvider(
      create: (context) => GetPartnerInfoCubit()..getPartnerInfoData(
          id,
          onSuccess: (userResult) {
            final user = userResult as IndividualUserModel;
            partnerInfo = [
              PartnerInfoModel(leading: Assets.svgLocation, title: LocaleKeys.city, subTitle: user.cityId.toString()),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.age, subTitle: user.age.toString()),

              PartnerInfoModel(leading: Assets.svgTallIcon, title: LocaleKeys.tall, subTitle: user.height.toString()),
              PartnerInfoModel(leading: Assets.svgWeight, title: LocaleKeys.weight, subTitle: user.weight.toString()),

              PartnerInfoModel(leading: Assets.svgParentIcon, title: LocaleKeys.skinColor, subTitle: user.skinColor),
              PartnerInfoModel(leading: Assets.svgMartialStatus, title: LocaleKeys.maritalStatus, subTitle: user.maritalStatus?.title),

              PartnerInfoModel(leading: Assets.svgEducationalQualification, title: LocaleKeys.educationalQualification, subTitle: user.educationLevel),
              PartnerInfoModel(leading: Assets.svgJob, title: LocaleKeys.currentJob, subTitle: user.currentJob),

              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenExists, subTitle: user.hasChildren.toString()),
              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenNumber, subTitle: user.numOfChildren.toString()),

              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.nursery, subTitle: user.childCustody?.title),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.wantToHaveChildren, subTitle: user.wantChildren.toString()),

              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.dowry, subTitle: '${LocaleKeys.from} ${user.dowryMin} ${LocaleKeys.to} ${user.dowryMax}'),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.typeOfWeddingParty, subTitle: user.weddingType?.title),

              PartnerInfoModel(leading: Assets.svgPrey, title: LocaleKeys.areYouPray, subTitle: user.isPrayer.toString()),
              PartnerInfoModel(leading: Assets.svgSmoke, title: LocaleKeys.areYouSmoke, subTitle: user.isSmoker.toString()),

              if(userResult.gender?.userType?.isFemale?? false)
                ...[
                  PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.doYouAcceptPolygamy, subTitle: (user as FemaleModel).acceptsPolygamy.toString()),
                  PartnerInfoModel(leading: Assets.svgHijab, title: LocaleKeys.areYouWaringHijab, subTitle: user.hijab),

                  PartnerInfoModel(leading: Assets.svgHome, title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage, subTitle: user.preferredResidenceAfterMarriage),
                ],
              PartnerInfoModel(leading: Assets.svgTribe, title: LocaleKeys.doYouBelongToATribe, subTitle: user.tribeAffiliation),

              PartnerInfoModel(leading: Assets.svgHospital, title: LocaleKeys.diseasesIfExists, subTitle: user.healthConditions),
              PartnerInfoModel(leading: Assets.svgTranslation, title: LocaleKeys.inChatYouPrefer, subTitle: user.chatLang),

              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant, subTitle: user.prohibitedThings),
            ];
          }
      ),
      child: CenterCardScaffold.withCenteredCard(
        upperWidget: BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => CachedImage(
              height: 200,
              url: state.data.avatar ?? '', fit: BoxFit.fill
            ),
          ),
        ),
        cardTopPadding: 200,
        centerCardBody: BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => Column(
              children: [
                Row(
                  children: [
                    AppText(state.data.name??'', fontWeight: FontWeight.bold),
                    const Spacer(),
                    CircleAvatar(
                      radius: 15.sp,
                      backgroundImage: NetworkImage(state.data.avatar??''),
                    ),
                    10.szW,
                    AppText(state.data.parentId.toString()),
                  ],
                ),

                AppText((state.data as IndividualUserModel).bio??''),
              ],
            ).paddingAll(12.r),
          ),
        ),

        bodyColor: AppColors.whiteGreyColorProMax,
        body: BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 2.5,
              children: List.generate(
                  partnerInfo.length,
                      (i) => InfoWidget(partnerInfoModel: partnerInfo[i])
              ),
            ),
          ),
        ),
      ),
    );
  }
}
