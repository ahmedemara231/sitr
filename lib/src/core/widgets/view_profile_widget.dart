import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/assets.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/auth/imports.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/presentation/imports.dart';
import '../../features/connection_requests/data/message_requests_data.dart';
import '../../features/connection_requests/presentation/widgets/reject_message_request_sheet.dart';
import '../../features/main_screen/data/models/partner_info_model.dart';
import '../../features/main_screen/presentation/screens/parent_details.dart';
import '../../features/main_screen/presentation/widgets/app_bar_actions.dart';
import '../../features/main_screen/presentation/widgets/partner_info/info_widget.dart';
import '../../features/more/presentation/cubit/edit_profile.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../extensions/bool.dart';
import '../extensions/context_extension.dart';
import '../extensions/num.dart';
import '../extensions/object.dart';
import '../extensions/padding_extension.dart';
import '../../features/chats/data/chat_sheet_manager.dart';
import '../extensions/sized_box_helper.dart';
import '../extensions/string_extension.dart';
import '../extensions/widget_extension.dart';
import '../helpers/status_builder.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../shared/convert_user_model_to_data_list_cubit.dart';
import '../shared/models/user_models/individual/female_model.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import '../shared/user_cubit/user_cubit.dart';
import 'app_text.dart' show AppText;
import 'buttons/default_button.dart';
import 'chat_availability_badge.dart';
import 'chat_button.dart';
import 'custom_messages.dart';
import 'image_widgets/cached_image.dart';
import 'premium_user_badge.dart';
import 'request_actions.dart';
import 'scaffolds/app_scaffold.dart';
import 'scaffolds/center_card_scaffold.dart';
import 'unavailability_reason_card.dart';
import 'sheets/bloc_success.dart';
import 'sheets/report_sheet.dart';

enum ProfileType { profile, partnerProfile }

extension TypeCheck on ProfileType {
  bool get isProfile => this == ProfileType.profile;
  bool get isPartnerProfile => this == ProfileType.partnerProfile;
}

class ViewProfileWidget<T extends GetUserModelCubit> extends StatefulWidget {
  final ProfileType _type;
  final T cubit;

  const ViewProfileWidget.profile({
    super.key,
    required this.cubit,
  }) : _type = ProfileType.profile;

  const ViewProfileWidget.viewPartner({
    super.key,
    required this.cubit,
  }) : _type = ProfileType.partnerProfile;

  @override
  State<ViewProfileWidget<T>> createState() => _ViewProfileWidgetState<T>();
}

class _ViewProfileWidgetState<T extends GetUserModelCubit>
    extends State<ViewProfileWidget<T>> {
  bool get _isNotAvailableToChat =>
      widget._type.isPartnerProfile && !user.canChat!.canChat;

  ChatReason? get _chatReason =>
      ChatReason.fromValue(user.canChat!.reason?.value);

  Widget _getAvailabilityStatus() {
    if (widget._type.isPartnerProfile) {
      return _isNotAvailableToChat
          ? const ChatAvailabilityBadge.notAvailable()
          : const ChatAvailabilityBadge.available();
    } else {
      return const SizedBox.shrink();
    }
  }

  late List<PartnerInfoModel> partnerInfo = [];
  late IndividualUserModel user = IndividualUserModel.initial();

  String _getDisplayName(UserModel profileUser) {
    final IndividualUserModel individualUser =
        profileUser as IndividualUserModel;
    final String nickName = individualUser.nickName?.trim() ?? '';
    return nickName.isNotEmpty ? nickName : profileUser.name ?? '';
  }

  Future<void> _acceptMessageRequest(UserModel profileUser) async {
    final int senderId = profileUser.id ?? 0;
    if (senderId == 0) return;

    final result = await MessageRequestsData.acceptMessageRequestFromSender(
      senderId: senderId,
    );
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.show(failure.message, state: MsgState.error);
      return;
    }
    if (!mounted) return;

    Go.to(
      ChatScreen(
        requestModel: RequestModel(
          receiverId: senderId.toString(),
          fromHome: 0.toString(),
        ),
        receiverName: _getDisplayName(profileUser),
      ),
    );
  }

  Future<bool> _rejectMessageRequest(UserModel profileUser) async {
    final int senderId = profileUser.id ?? 0;
    if (senderId == 0) return false;

    final result = await MessageRequestsData.rejectMessageRequestFromSender(
      senderId: senderId,
    );
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.show(failure.message, state: MsgState.error);
      return false;
    }
    if (!mounted) return false;

    Go.back();
    await widget.cubit.getProfile(onSuccess: _onSuccess);
    return true;
  }

  Future<void> _showRejectMessageRequestSheet(
    UserModel profileUser,
  ) async {
    await showRejectMessageRequestSheet(
      senderName: _getDisplayName(profileUser),
      onRejectConfirmed: () => _rejectMessageRequest(profileUser),
    );
  }

  void _onSuccess(UserModel userResult) {
    user = userResult as IndividualUserModel;
    partnerInfo = [
      PartnerInfoModel(
          leading: Assets.assets.svg.location.path,
          title: LocaleKeys.city,
          subTitle: user.cityId?.name),
      PartnerInfoModel(
          leading: Assets.assets.svg.recycing.path,
          title: LocaleKeys.age,
          subTitle: '${user.age} ${LocaleKeys.years}'),

      PartnerInfoModel(
          leading: Assets.assets.svg.tallIcon.path,
          title: LocaleKeys.tall,
          subTitle: '${user.height} ${LocaleKeys.centimeter}'),
      PartnerInfoModel(
          leading: Assets.assets.svg.weight.path,
          title: LocaleKeys.weight,
          subTitle: '${user.weight} ${LocaleKeys.kg}'),

      PartnerInfoModel(
          leading: Assets.assets.svg.parentIcon.path,
          title: LocaleKeys.skinColor,
          subTitle: user.skinColor?.title),
      PartnerInfoModel(
          leading: Assets.assets.svg.martialStatus.path,
          title: LocaleKeys.maritalStatus,
          subTitle: user.maritalStatus?.title),

      PartnerInfoModel(
          leading: Assets.assets.svg.educationalQualification.path,
          title: LocaleKeys.educationalQualification,
          subTitle: user.educationLevel),
      PartnerInfoModel(
          leading: Assets.assets.svg.job.path,
          title: LocaleKeys.currentJob,
          subTitle: user.currentJob),

      PartnerInfoModel(
          leading: Assets.assets.svg.parentChildren.path,
          title: LocaleKeys.childrenExists,
          subTitle: user.hasChildren?.toNormalLang()),
      PartnerInfoModel(
          leading: Assets.assets.svg.parentChildren.path,
          title: LocaleKeys.childrenNumber,
          subTitle: '${user.numOfChildren} ${LocaleKeys.children}'),

      PartnerInfoModel(
          leading: Assets.assets.svg.parentChildren.path,
          title: LocaleKeys.nursery,
          subTitle: user.childCustody?.title),
      PartnerInfoModel(
          leading: Assets.assets.svg.recycing.path,
          title: LocaleKeys.wantToHaveChildren,
          subTitle: user.wantChildren?.toNormalLang()),

      PartnerInfoModel(
          leading: Assets.assets.svg.recycing.path,
          title: LocaleKeys.dowry,
          subTitle:
              '${LocaleKeys.from} ${user.dowry?.from} ${LocaleKeys.to} ${user.dowry?.to}'),
      PartnerInfoModel(
          leading: Assets.assets.svg.recycing.path,
          title: LocaleKeys.typeOfWeddingParty,
          subTitle: user.weddingType?.title),

      PartnerInfoModel(
          leading: Assets.assets.svg.prey.path,
          title: LocaleKeys.areYouPray,
          subTitle: user.isPrayer?.toNormalLang()),
      PartnerInfoModel(
          leading: Assets.assets.svg.smoke.path,
          title: LocaleKeys.areYouSmoke,
          subTitle: user.isSmoker?.toNormalLang()),

      if (userResult.gender?.userGender?.isFemale ?? false) ...[
        PartnerInfoModel(
            leading: Assets.assets.svg.parentChildren.path,
            title: LocaleKeys.doYouAcceptPolygamy,
            subTitle: (user as FemaleModel).acceptsPolygamy?.toNormalLang()),
        PartnerInfoModel(
            leading: Assets.assets.svg.hijab.path,
            title: LocaleKeys.areYouWaringHijab,
            subTitle: (user as FemaleModel).hijab?.title),
        PartnerInfoModel(
            leading: Assets.assets.svg.home.path,
            title: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
            subTitle: (user as FemaleModel).preferredResidenceAfterMarriage),
      ],
      PartnerInfoModel(
          leading: Assets.assets.svg.tribe.path,
          title: LocaleKeys.doYouBelongToATribe,
          subTitle: user.tribeAffiliation?.toNormalLang()),

      PartnerInfoModel(
          leading: Assets.assets.svg.hospital.path,
          title: LocaleKeys.diseasesIfExists,
          subTitle: user.healthConditions),
      PartnerInfoModel(
          leading: Assets.assets.svg.translation.path,
          title: LocaleKeys.inChatYouPrefer,
          subTitle: user.chatLang?.toLang().toFullTitle()),

      // if(widget._type.isProfile)
      //   PartnerInfoModel(leading: Assets.assets.svg.profilePhone.path, title: LocaleKeys.phoneNumber, subTitle: user.phone),
    ];
  }

  double _calcCenterCardPadding(String bio) {
    // Width text can occupy inside the floating center card
    // (screen minus the card's outer horizontal margins + paddings).
    final double contentWidth = context.width - 50;

    final double bioHeight =
        _measureTextHeight(text: bio, maxWidth: contentWidth);

    double total = 24.r + 30.sp + 10.h + bioHeight;

    if (_isNotAvailableToChat) {
      total += 10.h + _unavailabilityCardHeight(contentWidth);
    }

    return total;
  }

  double _unavailabilityCardHeight(double contentWidth) {
    // The card adds 16.w of horizontal padding on each side.
    final double innerWidth = contentWidth - 32.w;
    final double titleHeight = _measureTextHeight(
      text: LocaleKeys.unavailabilityReason,
      maxWidth: innerWidth,
      fontSize: 12.sp,
    );
    final double bodyHeight = _measureTextHeight(
      text: _chatReason.getReason,
      maxWidth: innerWidth,
      fontSize: 10.sp,
    );
    return 28.h + titleHeight + 8.h + bodyHeight;
  }

  double _measureTextHeight({
    required String text,
    required double maxWidth,
    double fontSize = 14,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.cubit
        ..getProfile(onSuccess: (userResult) {
          _onSuccess(userResult);
        }),
      child: BlocBuilder<T, AsyncState<UserModel>>(
        builder: (context, state) => state.isError
            ? AppScaffold(
                body: Column(
                  children: [
                    AppText(LocaleKeys.chatReasonHasProblem, fontWeight: FontWeight.w500,),
                    Lottie.asset(Assets.assets.lottie.data.incompleteProfile.path),
                    DefaultButton(
                      title: LocaleKeys.back,
                      onTap: () => Go.back(),
                      borderRadius: BorderRadius.circular(10.r),
                    )
                  ],
                ),
              )
            : CenterCardScaffold.withCenteredCard(
                upperWidget: StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      StatusBuilder(
                        data: state,
                        onSuccess: (data, context) => CachedImage(
                            height: 200.h,
                            url: state.data.avatar ?? '',
                            fit: BoxFit.fill),
                      ),
                      Container(
                        width: context.width,
                        height: 200.h,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black38, Colors.black26])),
                      ),
                      if (widget._type.isProfile)
                        const ProfileAppBarActions.withBackButtonOnly()
                      else
                        ProfileAppBarActions(
                          onBlock: (context) => ChatSheetManager.show(
                            child: BlocManagerSheet(
                              id: state.data.id!,
                              blocManager: BlocManager.block,
                              onPress: () => 2.pop(),
                            ),
                          ),
                          onReport: (context) => ChatSheetManager.show(
                            child: ReportSheet(
                              id: state.data.id!,
                            ).paddingBottom(
                                MediaQuery.of(context).viewPadding.bottom),
                          ),
                        ),
                    ],
                  ),
                ),
                cardTopPadding: 150.h,
                centerCardBody: StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        if (user.childParentInfo.isNotNull)
                          Row(
                            children: [
                              Expanded(
                                child: PremiumUserName(
                                  name: (state.data as IndividualUserModel)
                                          .nickName ??
                                      '',
                                  isPremium: state.data.isPromoted,
                                ),
                              ),
                              8.szW,
                              InkWell(
                                onTap: () => Go.to(ParentDetailsScreen(
                                    id: user.childParentInfo?.id ?? 0)),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.sp,
                                      backgroundImage:
                                          NetworkImage(state.data.avatar ?? ''),
                                    ),
                                    10.szW,
                                    AppText(user.childParentInfo?.name ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PremiumUserName(
                                name: (state.data as IndividualUserModel)
                                        .nickName ??
                                    '',
                                isPremium: state.data.isPromoted,
                              ),
                              if (widget._type.isProfile)
                                AppText(
                                  '${LocaleKeys.numberOfProfileVisits} : ${state.data.views}',
                                  fontSize: 10.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            ],
                          ),
                        AppText((state.data as IndividualUserModel).bio ?? '',
                            textAlign: TextAlign.center),
                        _getAvailabilityStatus(),
                        if (_isNotAvailableToChat)
                          UnavailabilityReasonCard(reason: _chatReason),
                      ],
                    ).paddingAll(12.r),
                  ),
                ),
                bodyColor: AppColors.whiteGreyColorProMax,
                bodyTopPadding: state.isLoading
                    ? 0
                    : _calcCenterCardPadding(
                        (state.data as IndividualUserModel).bio ?? ''),
                body: StatusBuilder(
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
                        itemBuilder: (BuildContext context, int index) =>
                            InfoWidget(partnerInfoModel: partnerInfo[index]),
                      ),
                      InfoWidget(
                          partnerInfoModel: PartnerInfoModel(
                              leading: Assets.assets.svg.recycing.path,
                              title:
                                  LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
                              subTitle: user.prohibitedThings)),
                      if (widget._type.isPartnerProfile)
                        if (state.data.hasChatRequestFrom)
                          RequestActions(
                            canAccept: true,
                            onAcceptPressed: () =>
                                _acceptMessageRequest(state.data),
                            onRejectPressed: () =>
                                _showRejectMessageRequestSheet(state.data),
                          )
                        else
                          ChatButton(user: state.data)
                      else if (widget._type.isProfile)
                        DefaultButton(
                          borderRadius: BorderRadius.circular(40.r),
                          title: LocaleKeys.editProfile,
                          onTap: () =>
                              Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
                            scaffoldType: ScaffoldType.appScaffold,
                            userType: UserModel.currentUser?.gender?.userGender,
                            showGenderSelection: false,
                            initialValue:
                                UserModel.currentUser as IndividualUserModel,
                            onClick: (context, user) => context
                                .read<EditProfileCubit>()
                                .editProfile(
                                  body: user,
                                  onSuccess: (data) {
                                    UserCubit.instance.updateUser(data.data);
                                    MessageUtils.show(
                                      data.msg,
                                      state: MsgState.success,
                                    );
                                    Go.back();
                                    widget.cubit.getProfile(
                                        onSuccess: (userResult) {
                                      _onSuccess(userResult);
                                    });
                                  },
                                ),
                          )),
                        ),
                    ],
                  ),
                ),
              ).withPullRefresher(onRefresh: () {
                widget.cubit.getProfile(onSuccess: (userResult) {
                  _onSuccess(userResult);
                });
              }),
      ),
    );
  }
}
