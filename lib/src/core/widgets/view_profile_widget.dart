import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/res/config_imports.dart';
import '../../features/auth/imports.dart';
import '../../features/chats/data/chat_sheet_manager.dart';
import '../../features/chats/data/models/request_model.dart';
import '../../features/chats/presentation/imports.dart';
import '../../features/connection_requests/data/message_requests_data.dart';
import '../../features/connection_requests/presentation/widgets/reject_message_request_sheet.dart';
import '../../features/main_screen/presentation/screens/parent_details.dart';
import '../../features/more/presentation/cubit/edit_profile.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../extensions/num.dart';
import '../extensions/padding_extension.dart';
import '../helpers/status_builder.dart';
import '../navigation/navigator.dart';
import '../shared/convert_user_model_to_data_list_cubit.dart';
import '../shared/models/user_models/individual/individual_user_model.dart';
import '../shared/models/user_models/user_model.dart';
import '../shared/user_cubit/user_cubit.dart';
import 'custom_messages.dart';
import 'sheets/bloc_success.dart';
import 'sheets/report_sheet.dart';
import 'view_profile/mappers/profile_sections_mapper.dart';
import 'view_profile/models/profile_section_model.dart';
import 'view_profile/models/profile_type.dart';
import 'view_profile/widgets/header/profile_header.dart';
import 'view_profile/widgets/profile_actions.dart';
import 'view_profile/widgets/profile_content.dart';
import 'view_profile/widgets/profile_error_view.dart';

export 'view_profile/models/profile_type.dart';

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
  bool _isNotAvailableToChat(IndividualUserModel profileUser) =>
      widget._type.isPartnerProfile && !(profileUser.canChat?.canChat ?? false);

  ChatReason? _chatReason(IndividualUserModel profileUser) =>
      ChatReason.fromValue(profileUser.canChat?.reason?.value);

  String _displayName(IndividualUserModel profileUser) {
    final String nickname = profileUser.nickName?.trim() ?? '';
    return nickname.isNotEmpty ? nickname : profileUser.name?.trim() ?? '';
  }

  Future<void> _acceptMessageRequest(IndividualUserModel profileUser) async {
    final int senderId = profileUser.id ?? 0;
    if (senderId == 0) {
      return;
    }

    final result = await MessageRequestsData.acceptMessageRequestFromSender(
      senderId: senderId,
    );
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.show(failure.message, state: MsgState.error);
      return;
    }
    if (!mounted) {
      return;
    }

    Go.to(
      ChatScreen(
        requestModel: RequestModel(
          receiverId: senderId.toString(),
          fromHome: 0.toString(),
        ),
        receiverName: _displayName(profileUser),
      ),
    );
  }

  Future<bool> _rejectMessageRequest(
    IndividualUserModel profileUser,
  ) async {
    final int senderId = profileUser.id ?? 0;
    if (senderId == 0) {
      return false;
    }

    final result = await MessageRequestsData.rejectMessageRequestFromSender(
      senderId: senderId,
    );
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.show(failure.message, state: MsgState.error);
      return false;
    }
    if (!mounted) {
      return false;
    }

    Go.back();
    await widget.cubit.getProfile();
    return true;
  }

  Future<void> _showRejectMessageRequestSheet(
    IndividualUserModel profileUser,
  ) async {
    await showRejectMessageRequestSheet(
      senderName: _displayName(profileUser),
      onRejectConfirmed: () => _rejectMessageRequest(profileUser),
    );
  }

  void _openEditProfile() {
    Go.to(
      EnterMaleOrFemaleOrChildDataScreen.showAll(
        scaffoldType: ScaffoldType.appScaffold,
        userType: UserModel.currentUser?.gender?.userGender,
        showGenderSelection: false,
        initialValue: UserModel.currentUser as IndividualUserModel,
        onClick: (BuildContext context, IndividualUserModel user) =>
            context.read<EditProfileCubit>().editProfile(
                  body: user,
                  onSuccess: (data) {
                    UserCubit.instance.updateUser(data.data);
                    MessageUtils.show(
                      data.msg,
                      state: MsgState.success,
                    );
                    Go.back();
                    widget.cubit.getProfile();
                  },
                ),
      ),
    );
  }

  Widget _profileHeader(IndividualUserModel profileUser) {
    return ProfileHeader(
      profileUser: profileUser,
      displayName: _displayName(profileUser),
      isOwnProfile: widget._type.isProfile,
      isUnavailable: _isNotAvailableToChat(profileUser),
      chatReason: _chatReason(profileUser),
      onParentPressed: profileUser.childParentInfo == null
          ? null
          : () => Go.to(
                ParentDetailsScreen(id: profileUser.childParentInfo!.id),
              ),
      onReportPressed: widget._type.isProfile
          ? null
          : () => ChatSheetManager.show(
                child: ReportSheet(id: profileUser.id ?? 0).paddingBottom(
                  MediaQuery.of(context).viewPadding.bottom,
                ),
              ),
      onBlockPressed: widget._type.isProfile
          ? null
          : () => ChatSheetManager.show(
                child: BlocManagerSheet(
                  id: profileUser.id ?? 0,
                  blocManager: BlocManager.block,
                  onPress: () => 2.pop(),
                ),
              ),
    );
  }

  Widget _profileActions(IndividualUserModel profileUser) {
    return ProfileActions(
      profileUser: profileUser,
      isOwnProfile: widget._type.isProfile,
      onAcceptPressed: () => _acceptMessageRequest(profileUser),
      onRejectPressed: () => _showRejectMessageRequestSheet(profileUser),
      onEditPressed: _openEditProfile,
    );
  }

  Widget _profileContent(IndividualUserModel profileUser) {
    final List<ProfileSectionModel> sections = ProfileSectionsMapper.map(
      profileUser: profileUser,
      isOwnProfile: widget._type.isProfile,
    );
    return ProfileContent(
      header: _profileHeader(profileUser),
      actions: _profileActions(profileUser),
      sections: sections,
      onRefresh: widget.cubit.getProfile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (BuildContext context) => widget.cubit..getProfile(),
      child: BlocBuilder<T, AsyncState<UserModel>>(
        builder: (BuildContext context, AsyncState<UserModel> state) {
          if (state.isError) {
            return const ProfileErrorView();
          }

          return Scaffold(
            backgroundColor: AppColors.whiteScaffoldBackground,
            body: SafeArea(
              child: StatusBuilder<UserModel>(
                data: state,
                onSuccess: (UserModel data, BuildContext context) =>
                    _profileContent(data as IndividualUserModel),
              ),
            ),
          );
        },
      ),
    );
  }
}
