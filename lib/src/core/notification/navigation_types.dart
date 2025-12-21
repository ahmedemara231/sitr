part of 'notification_service.dart';

enum NotificationType {
  // 🔔 Admin & System Notifications
  adminNotify('admin_notify', navigation: NoNavigation()),
  text('text', navigation: MatchRequestNavigation()),
  accountDeletedByAdmin('account_deleted_by_admin', navigation: LoginNavigation()),
  block('block', navigation: LoginNavigation()),
  unblocked('unblocked', navigation: UpdateNavigation()),
  userUnblockedYou('user_unblocked_you', navigation: UserUnblockedYou()),
  adminProfileUpdated('admin_profile_updated', navigation: ProfileNavigation()),

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

  parentIndividualApprovalRejected('parent_individual_approval_rejected', navigation: HomeNavigation()),
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
  adminAddedChild('admin_added_child', navigation: AdminActionWithChild()),

  // action with Children
  adminRejectChild('admin_rejected_child', navigation: AdminActionWithChild()),
  adminApprovedChild('admin_approved_child', navigation: AdminActionWithChild()),

  // 💰 Package and Code
  adminAssignedPackage('admin_assigned_package', navigation: PackagesNavigation()),
  adminAssignedSetrCode('admin_assigned_setr_code', navigation: NoNavigation()),
  packageExpired('package_expired', navigation: PackagesNavigation()),
  setrCodeExpired('setr_code_expired', navigation: SetrCodeNavigation());

  final String type;
  final NotificationNavigation navigation;
  const NotificationType(this.type, {required this.navigation});
}

extension CheckType on NotificationType{
  bool get isSystemNotification => this == NotificationType.adminNotify;
  bool get isBlock => this == NotificationType.block;
  bool get isProfileVisit => this == NotificationType.profileVisit;
  bool get isComplaintReply => this == NotificationType.complaintReply;
  bool get isComplaintInProgress => this == NotificationType.complaintInProgress;
  bool get isUserAcceptedNextStage => this == NotificationType.userAcceptedNextStage;
  bool get isStageChanged => this == NotificationType.stageChanged;
  bool get isNextStageRequestSent => this == NotificationType.nextStageRequestSent;
  bool get isContinueStageRequestSent => this == NotificationType.continueStageRequestSent;
  bool get isExtensionRequestSent => this == NotificationType.extensionRequestSent;
  bool get isVideoCallRequestSent => this == NotificationType.videoCallRequestSent;
  bool get isAdminMeetingRequestSent => this == NotificationType.adminMeetingRequestSent;
  bool get isParentMeetingRequestSent => this == NotificationType.parentMeetingRequestSent;
  bool get isParentExchangeNumbersSent => this == NotificationType.parentExchangeNumbersSent;
  bool get isExtensionRequestAccepted => this == NotificationType.extensionRequestAccepted;
  bool get isVideoCallRequestAccepted => this == NotificationType.videoCallRequestAccepted;
  bool get isParentMeetingRequestAccepted => this == NotificationType.parentMeetingRequestAccepted;
  bool get isAdminMeetingRequestAccepted => this == NotificationType.adminMeetingRequestAccepted;
  bool get isContinueStageRequestAccepted => this == NotificationType.continueStageRequestAccepted;
  bool get isParentExchangeNumbersAccepted => this == NotificationType.parentExchangeNumbersAccepted;
  bool get isNextStageRequestRejected => this == NotificationType.nextStageRequestRejected;
  bool get isContinueStageRequestRejected => this == NotificationType.continueStageRequestRejected;
  bool get isExtensionRequestRejected => this == NotificationType.extensionRequestRejected;
  bool get isVideoCallRequestRejected => this == NotificationType.videoCallRequestRejected;
  bool get isAdminMeetingRequestRejected => this == NotificationType.adminMeetingRequestRejected;
  bool get isParentMeetingRequestRejected => this == NotificationType.parentMeetingRequestRejected;
  bool get isParentIndividualApprovalRejected => this == NotificationType.parentIndividualApprovalRejected;
  bool get isMatchRejectedWhenTimerEnded => this == NotificationType.matchRejectedWhenTimerEnded;
  bool get isMatchRequestCompleted => this == NotificationType.matchRequestCompleted;
  bool get isChattingTimerEnded => this == NotificationType.chattingTimerEnded;
  bool get isShariaComplaintMeetingTimerEnded => this == NotificationType.shariaComplaintMeetingTimerEnded;
  bool get isIstikharahTimerEnded => this == NotificationType.istikharahTimerEnded;
  bool get isFullParentConversationTimerEnded => this == NotificationType.fullParentConversationTimerEnded;
  bool get isExtensionTimerEnded => this == NotificationType.extensionTimerEnded;
  bool get isExtensionRequestPaid => this == NotificationType.extensionRequestPaid;
  bool get isVideoCallRequestPaid => this == NotificationType.videoCallRequestPaid;
  bool get isAdminMeetingRequestPaid => this == NotificationType.adminMeetingRequestPaid;
  bool get isParentIndividualTimerEnded => this == NotificationType.parentIndividualTimerEnded;
  bool get isParentApprovedIndividual => this == NotificationType.parentApprovedIndividual;
  bool get isParentApprovedToChildren => this == NotificationType.parentApprovedToChildren;
  bool get isPackageExpired => this == NotificationType.packageExpired;
  bool get isSetrCodeExpired => this == NotificationType.setrCodeExpired;
  bool get isAccountDeletedByAdmin => this == NotificationType.accountDeletedByAdmin;
}
