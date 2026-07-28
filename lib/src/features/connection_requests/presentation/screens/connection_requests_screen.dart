import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_pagify.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import '../../../chats/data/models/request_model.dart';
import '../../../chats/presentation/imports.dart';
import '../../../main_screen/data/models/filter_model.dart';
import '../../../main_screen/presentation/cubits/get_partner_info_cubit.dart';
import '../../../main_screen/presentation/screens/filter_result.dart';
import '../../data/message_requests_data.dart';
import '../../data/models/message_request_model.dart';
import '../widgets/connection_requests_empty_view.dart';
import '../widgets/message_request_card.dart';
import '../widgets/reject_message_request_sheet.dart';

class ConnectionRequestsScreen extends StatefulWidget {
  const ConnectionRequestsScreen({super.key});

  @override
  State<ConnectionRequestsScreen> createState() =>
      _ConnectionRequestsScreenState();
}

class _ConnectionRequestsScreenState extends State<ConnectionRequestsScreen> {
  late final PagifyController<MessageRequestModel> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PagifyController<MessageRequestModel>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onExploreProfilesPressed() =>
      Go.to(FilterResultScreen(filterModel: FilterModel.initial()));

  void _viewProfile(MessageRequestModel request) {
    Go.to(
      ViewProfileWidget<GetPartnerInfoCubit>.viewPartner(
        cubit: GetPartnerInfoCubit(request.sender.id),
      ),
    );
  }

  Future<void> _acceptMessageRequest(MessageRequestModel request) async {
    final result = await MessageRequestsData.acceptMessageRequest(request);
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.showTopMsg(failure.message);
      return;
    }
    if (!mounted) return;
    _controller.removeWhere((item) => item.id == request.id);
    Go.to(
      ChatScreen(
        requestModel: RequestModel(
          receiverId: request.sender.id.toString(),
          fromHome: 0.toString(),
        ),
        receiverName: request.sender.displayName,
      ),
    );
  }

  Future<bool> _rejectMessageRequest(MessageRequestModel request) async {
    final result = await MessageRequestsData.rejectMessageRequest(request);
    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.showTopMsg(failure.message);
      return false;
    }
    if (!mounted) return false;
    _controller.removeWhere((item) => item.id == request.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: false,
      appBarTitle: LocaleKeys.connectionRequests,
      body: AppPagify<MessageRequestModel>(
        pagifyController: _controller,
        asyncCall: (_, page) => MessageRequestsData.getMessageRequests(page),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: false,
        emptyWidget: ConnectionRequestsEmptyView(
          onExploreProfilesPressed: _onExploreProfilesPressed,
        ),
        itemBuilder: (_, data, index, request) {
          return MessageRequestCard(
            request: request,
            onProfilePressed: () => _viewProfile(request),
            onAcceptPressed: () => _acceptMessageRequest(request),
            onRejectPressed: () => showRejectMessageRequestSheet(
              senderName: request.sender.displayName,
              onRejectConfirmed: () => _rejectMessageRequest(request),
            ),
          ).paddingOnly(
            left: 16.w,
            right: 16.w,
            bottom: 12.h,
          );
        },
      ).withPullRefresher(
        onRefresh: () => _controller.refresh(),
      ),
    );
  }
}
