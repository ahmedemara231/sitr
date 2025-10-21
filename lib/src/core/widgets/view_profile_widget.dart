import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/chats/presentation/screens/chat_screen.dart';
import '../../features/main_screen/data/models/partner_info_model.dart';
import '../../features/main_screen/presentation/widgets/app_bar_actions.dart';
import '../../features/main_screen/presentation/widgets/partner_info/info_widget.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import '../extensions/sized_box_helper.dart';
import '../helpers/status_builder.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../shared/convert_user_model_to_data_list_cubit.dart';
import '../shared/models/user_models/individual/female_model.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import 'app_text.dart' show AppText;
import 'buttons/custom_app_buttons/default_button.dart';
import 'buttons/custom_app_buttons/loading_button.dart';
import 'image_widgets/cached_image.dart';
import 'scaffolds/auth_scaffold.dart';

enum ProfileType{profile, partnerProfile}

extension TypeCheck on ProfileType{
  bool get isProfile => this == ProfileType.profile;
  bool get isPartnerProfile => this == ProfileType.partnerProfile;
}

class ViewProfileWidget<T extends GetUserModelCubit> extends StatelessWidget {
  final ProfileType _type;
  final T cubit;

  const ViewProfileWidget.profile({super.key,
    required this.cubit,
  }) : _type = ProfileType.profile,
        receiverId = null;

  final int? receiverId;
  // final int? fromHome;

  const ViewProfileWidget.viewPartner({super.key,
    required this.cubit,
    required this.receiverId,
  }) : _type = ProfileType.partnerProfile;

  @override
  Widget build(BuildContext context) {
    late List<PartnerInfoModel> partnerInfo = [];
    return BlocProvider(
      create: (context) => cubit..getProfile(
          onSuccess: (userResult) {
            final user = userResult as IndividualUserModel;
            partnerInfo = [
              PartnerInfoModel(leading: Assets.svgLocation, title: LocaleKeys.city, subTitle: user.cityId?.name),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.age, subTitle: user.age.toString()),

              PartnerInfoModel(leading: Assets.svgTallIcon, title: LocaleKeys.tall, subTitle: user.height.toString()),
              PartnerInfoModel(leading: Assets.svgWeight, title: LocaleKeys.weight, subTitle: user.weight.toString()),

              PartnerInfoModel(leading: Assets.svgParentIcon, title: LocaleKeys.skinColor, subTitle: user.skinColor?.title),
              PartnerInfoModel(leading: Assets.svgMartialStatus, title: LocaleKeys.maritalStatus, subTitle: user.maritalStatus?.title),

              PartnerInfoModel(leading: Assets.svgEducationalQualification, title: LocaleKeys.educationalQualification, subTitle: user.educationLevel),
              PartnerInfoModel(leading: Assets.svgJob, title: LocaleKeys.currentJob, subTitle: user.currentJob),

              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenExists, subTitle: user.hasChildren.toString()),
              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenNumber, subTitle: user.numOfChildren.toString()),

              PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.nursery, subTitle: user.childCustody?.title),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.wantToHaveChildren, subTitle: user.wantChildren.toString()),

              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.dowry, subTitle: '${LocaleKeys.from} ${user.dowry?.from} ${LocaleKeys.to} ${user.dowry?.to}'),
              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.typeOfWeddingParty, subTitle: user.weddingType?.title),

              PartnerInfoModel(leading: Assets.svgPrey, title: LocaleKeys.areYouPray, subTitle: user.isPrayer.toString()),
              PartnerInfoModel(leading: Assets.svgSmoke, title: LocaleKeys.areYouSmoke, subTitle: user.isSmoker.toString()),

              if(userResult.gender?.userType?.isFemale?? false)
                ...[
                  PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.doYouAcceptPolygamy, subTitle: (user as FemaleModel).acceptsPolygamy.toString()),
                  PartnerInfoModel(leading: Assets.svgHijab, title: LocaleKeys.areYouWaringHijab, subTitle: user.hijab?.title),

                  PartnerInfoModel(leading: Assets.svgHome, title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage, subTitle: user.preferredResidenceAfterMarriage),
                ],
              PartnerInfoModel(leading: Assets.svgTribe, title: LocaleKeys.doYouBelongToATribe, subTitle: user.tribeAffiliation.toString()),

              PartnerInfoModel(leading: Assets.svgHospital, title: LocaleKeys.diseasesIfExists, subTitle: user.healthConditions),
              PartnerInfoModel(leading: Assets.svgTranslation, title: LocaleKeys.inChatYouPrefer, subTitle: user.chatLang),

              PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant, subTitle: user.prohibitedThings),

              if(_type.isProfile)
                PartnerInfoModel(leading: Assets.svgProfilePhone, title: LocaleKeys.phoneNumber, subTitle: user.phone),
            ];
          }
      ),
      child: CenterCardScaffold.withCenteredCard(
        upperWidget: BlocBuilder<T, AsyncState<UserModel>>(
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

              if(_type.isProfile)
                const ProfileAppBarActions.withBackButtonOnly()
              else
                ProfileAppBarActions(onBlock: (context){}, onReport: (context){}),
            ],
          ),
        ),

        cardTopPadding: 200,
        centerCardBody: BlocBuilder<T, AsyncState<UserModel>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => SizedBox(
              width: context.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  if(_type.isPartnerProfile)
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
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(state.data.name??'', fontWeight: FontWeight.bold),
                        AppText(
                          '${LocaleKeys.numberOfProfileVisits}: ${(state.data as IndividualUserModel).views}',
                          fontSize: 10.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),

                  AppText((state.data as IndividualUserModel).bio??'', textAlign: TextAlign.center),
                ],
              ).paddingAll(12.r),
            ),
          ),
        ),

        bodyColor: AppColors.whiteGreyColorProMax,
        body: BlocBuilder<T, AsyncState<UserModel>>(
          builder: (context, state) => Column(
            spacing: 14.h,
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
                          (i) => InfoWidget(partnerInfoModel: partnerInfo[i])
                  ),
                ),
              ),
              if(_type.isPartnerProfile)
                AppDefaultButton.withBackGroundColor(
                  onTap: () => Go.to(ChatScreen(
                    receiverId: receiverId ?? 0,
                    fromHome: 1,
                  )),
                  title: LocaleKeys.startChat,
                )
            ],
          ),
        ),
      ),
    );
  }
}