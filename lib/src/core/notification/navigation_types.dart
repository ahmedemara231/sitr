part of 'notification_service.dart';

enum NotificationType {
  // 🔔 Admin & System Notifications
  adminNotify('admin_notify', navigation: HomeNavigation()),
  block('block', navigation: BlockNavigation()),
  unblocked('unblocked', navigation: UpdateNavigation()),
  userUnblockedYou('user_unblocked_you', navigation: UserUnblockedYou()),

  // 📋 Complaints
  complaintReply('complaint_reply', navigation: ComplaintNavigation()),
  complaintInProgress('complaint_in_progress', navigation: ComplaintNavigation()),

  // 👤 Profile
  profileVisit('profile_visit', navigation: UserProfileNavigation()),

  // 🧾 Admin Approvals
  adminApprovedUser('admin_approved_user', navigation: UpdateNavigation()),
  adminRejectedUser('admin_rejected_user', navigation: UpdateNavigation()),
  ownerApproved('owner_approved', navigation: UpdateNavigation()),
  providerAccepted('provider_accepted', navigation: UpdateNavigation()),
  providerRejected('provider_rejected', navigation: UpdateNavigation()),

  // 💬 Match Request Notifications (many types)
  userAcceptedNextStage('user_accepted_next_stage', navigation: MatchRequestNavigation()),
  stageChanged('stage_changed', navigation: MatchRequestNavigation()),
  nextStageRequestSent('next_stage_request_sent', navigation: MatchRequestNavigation()),
  continueStageRequestSent('continue_stage_request_sent', navigation: MatchRequestNavigation()),
  extensionRequestSent('extension_request_sent', navigation: MatchRequestNavigation()),
  videoCallRequestSent('video_call_request_sent', navigation: MatchRequestNavigation()),
  adminMeetingRequestSent('admin_meeting_request_sent', navigation: MatchRequestNavigation()),
  parentMeetingRequestSent('parent_meeting_request_sent', navigation: MatchRequestNavigation()),
  parentExchangeNumbersSent('parent_exchange_numbers_sent', navigation: MatchRequestNavigation()),

  extensionRequestAccepted('extension_request_accepted', navigation: MatchRequestNavigation()),
  videoCallRequestAccepted('video_call_request_accepted', navigation: MatchRequestNavigation()),
  parentMeetingRequestAccepted('parent_meeting_request_accepted', navigation: MatchRequestNavigation()),
  adminMeetingRequestAccepted('admin_meeting_request_accepted', navigation: MatchRequestNavigation()),
  continueStageRequestAccepted('continue_stage_request_accepted', navigation: MatchRequestNavigation()),
  parentExchangeNumbersAccepted('parent_exchange_numbers_accepted', navigation: MatchRequestNavigation()),

  nextStageRequestRejected('next_stage_request_rejected', navigation: MatchRequestNavigation()),
  continueStageRequestRejected('continue_stage_request_rejected', navigation: MatchRequestNavigation()),
  extensionRequestRejected('extension_request_rejected', navigation: MatchRequestNavigation()),
  videoCallRequestRejected('video_call_request_rejected', navigation: MatchRequestNavigation()),
  adminMeetingRequestRejected('admin_meeting_request_rejected', navigation: MatchRequestNavigation()),
  parentMeetingRequestRejected('parent_meeting_request_rejected', navigation: MatchRequestNavigation()),
  parentIndividualApprovalRejected('parent_individual_approval_rejected', navigation: MatchRequestNavigation()),
  matchRejectedWhenTimerEnded('match_rejected_when_timer_ended', navigation: HomeNavigation()),

  matchRequestCompleted('match_request_completed', navigation: HomeNavigation()),
  chattingTimerEnded('chatting_timer_ended', navigation: MatchRequestNavigation()),
  shariaComplaintMeetingTimerEnded('sharia_complaint_meeting_timer_ended', navigation: MatchRequestNavigation()),
  istikharahTimerEnded('istikharah_timer_ended', navigation: MatchRequestNavigation()),
  fullParentConversationTimerEnded('full_parent_conversation_timer_ended', navigation: MatchRequestNavigation()),
  extensionTimerEnded('extension_timer_ended', navigation: MatchRequestNavigation()),

  extensionRequestPaid('extension_request_paid', navigation: MatchRequestNavigation()),
  videoCallRequestPaid('video_call_request_paid', navigation: MatchRequestNavigation()),
  adminMeetingRequestPaid('admin_meeting_request_paid', navigation: MatchRequestNavigation()),

  parentIndividualTimerEnded('parent_individual_timer_ended', navigation: MatchRequestNavigation()),
  parentApprovedIndividual('parent_approved_individual', navigation: MatchRequestNavigation()),
  parentApprovedToChildren('parent_approved_to_children', navigation: MatchRequestNavigation()),

  // 💰 Package and Code
  packageExpired('package_expired', navigation: PackagesNavigation()),
  setrCodeExpired('setr_code_expired', navigation: SetrCodeNavigation());

  final String type;
  final NotificationNavigation navigation;
  const NotificationType(this.type, {required this.navigation});
}

