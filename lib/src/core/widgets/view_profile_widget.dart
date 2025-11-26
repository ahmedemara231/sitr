import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../generated/assets.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/main_screen/data/models/partner_info_model.dart';
import '../../features/main_screen/presentation/screens/parent_details.dart';
import '../../features/main_screen/presentation/widgets/app_bar_actions.dart';
import '../../features/main_screen/presentation/widgets/partner_info/info_widget.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../dropinity/helpers/extensions/object.dart';
import '../extensions/bool.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import '../extensions/sized_box_helper.dart';
import '../extensions/string_extension.dart';
import '../helpers/status_builder.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../shared/convert_user_model_to_data_list_cubit.dart';
import '../shared/models/user_models/individual/female_model.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import 'app_text.dart' show AppText;
import 'chat_button.dart';
import 'default_bottom_sheet.dart';
import 'image_widgets/cached_image.dart';
import 'scaffolds/auth_scaffold.dart';
import 'sheets/bloc_success.dart';
import 'sheets/report_cheet.dart';

enum ProfileType{profile, partnerProfile}

extension TypeCheck on ProfileType{
  bool get isProfile => this == ProfileType.profile;
  bool get isPartnerProfile => this == ProfileType.partnerProfile;
}

class ViewProfileWidget<T extends GetUserModelCubit> extends StatefulWidget {
  final ProfileType _type;
  final T cubit;

  const ViewProfileWidget.profile({super.key,
    required this.cubit,
  }) : _type = ProfileType.profile;

  const ViewProfileWidget.viewPartner({super.key,
    required this.cubit,
  }) : _type = ProfileType.partnerProfile;

  @override
  State<ViewProfileWidget<T>> createState() => _ViewProfileWidgetState<T>();
}

class _ViewProfileWidgetState<T extends GetUserModelCubit> extends State<ViewProfileWidget<T>> {
  late List<PartnerInfoModel> partnerInfo = [];
  late final IndividualUserModel user;
  void _onSuccess(UserModel userResult){
    user = userResult as IndividualUserModel;
    partnerInfo = [
      PartnerInfoModel(leading: Assets.svgLocation, title: LocaleKeys.city, subTitle: user.cityId?.name),
      PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.age, subTitle: '${user.age} ${LocaleKeys.years}'),

      PartnerInfoModel(leading: Assets.svgTallIcon, title: LocaleKeys.tall, subTitle: '${user.height} ${LocaleKeys.centimeter}'),
      PartnerInfoModel(leading: Assets.svgWeight, title: LocaleKeys.weight, subTitle: '${user.weight} ${LocaleKeys.kg}'),

      PartnerInfoModel(leading: Assets.svgParentIcon, title: LocaleKeys.skinColor, subTitle: user.skinColor?.title),
      PartnerInfoModel(leading: Assets.svgMartialStatus, title: LocaleKeys.maritalStatus, subTitle: user.maritalStatus?.title),

      PartnerInfoModel(leading: Assets.svgEducationalQualification, title: LocaleKeys.educationalQualification, subTitle: user.educationLevel),
      PartnerInfoModel(leading: Assets.svgJob, title: LocaleKeys.currentJob, subTitle: user.currentJob),

      PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenExists, subTitle: user.hasChildren!.toNormalLang()),
      PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenNumber, subTitle: '${user.numOfChildren} ${LocaleKeys.children}'),

      PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.nursery, subTitle: user.childCustody?.title),
      PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.wantToHaveChildren, subTitle: user.wantChildren!.toNormalLang()),

      PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.dowry, subTitle: '${LocaleKeys.from} ${user.dowry?.from} ${LocaleKeys.to} ${user.dowry?.to}'),
      PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.typeOfWeddingParty, subTitle: user.weddingType?.title),

      PartnerInfoModel(leading: Assets.svgPrey, title: LocaleKeys.areYouPray, subTitle: user.isPrayer!.toNormalLang()),
      PartnerInfoModel(leading: Assets.svgSmoke, title: LocaleKeys.areYouSmoke, subTitle: user.isSmoker!.toNormalLang()),

      if(userResult.gender?.userType?.isFemale?? false)
        ...[
          PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.doYouAcceptPolygamy, subTitle: (user as FemaleModel).acceptsPolygamy.toString()),
          PartnerInfoModel(leading: Assets.svgHijab, title: LocaleKeys.areYouWaringHijab, subTitle: (user as FemaleModel).hijab?.title),

          PartnerInfoModel(leading: Assets.svgHome, title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage, subTitle: (user as FemaleModel).preferredResidenceAfterMarriage),
        ],
      PartnerInfoModel(leading: Assets.svgTribe, title: LocaleKeys.doYouBelongToATribe, subTitle: user.tribeAffiliation!.toNormalLang()),

      PartnerInfoModel(leading: Assets.svgHospital, title: LocaleKeys.diseasesIfExists, subTitle: user.healthConditions),
      PartnerInfoModel(leading: Assets.svgTranslation, title: LocaleKeys.inChatYouPrefer, subTitle: user.chatLang!.toLang().toFullTitle()),

      PartnerInfoModel(leading: Assets.svgRecycing, title: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant, subTitle: user.prohibitedThings),

      if(widget._type.isProfile)
        PartnerInfoModel(leading: Assets.svgProfilePhone, title: LocaleKeys.phoneNumber, subTitle: user.phone),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.cubit..getProfile(
          onSuccess: (userResult) {
            _onSuccess(userResult);
          }
      ),
      child: CenterCardScaffold.withCenteredCard(
        onRefresh: (context) => widget.cubit.getProfile(
            onSuccess: (userResult) {
              _onSuccess(userResult);
            }
        ),
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

              if(widget._type.isProfile)
                const ProfileAppBarActions.withBackButtonOnly()
              else
                ProfileAppBarActions(
                    onBlock: (context) => showDefaultBottomSheet(
                      child: BlocManagerSheet(
                          id: state.data.id!,
                          blocManager: BlocManager.block
                      ),
                    ),
                    onReport: (context) => showDefaultBottomSheet(
                      child: ReportSheet(
                          id: state.data.id!,
                      ),
                    ),
                ),
            ],
          ),
        ),

        cardTopPadding: 150.h,
        centerCardBody: BlocBuilder<T, AsyncState<UserModel>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => SizedBox(
              width: context.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  if(user.childParentInfo.isNotNull)
                    Row(
                      children: [
                        AppText(state.data.name??'', fontWeight: FontWeight.bold),
                        const Spacer(),
                        InkWell(
                          onTap: () => Go.to(ParentDetailsScreen(id: user.childParentInfo?.id ?? 0)),

                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15.sp,
                                backgroundImage: NetworkImage(state.data.avatar??''),
                              ),
                              10.szW,
                              AppText(user.childParentInfo?.name??''),
                            ],
                          ),
                        )

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
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => Column(
              spacing: 22.h,
              children: [
                MasonryGridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  // childAspectRatio: 2.5,
                  itemCount: partnerInfo.length,
                  itemBuilder: (BuildContext context, int index) => InfoWidget(partnerInfoModel: partnerInfo[index]),
                ),

                if(widget._type.isPartnerProfile)
                  ChatButton(user: state.data),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
