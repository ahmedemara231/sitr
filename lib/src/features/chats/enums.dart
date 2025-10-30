enum UserRequestStatus{
  pending(0, 'pending'),
  accepted(1, 'accepted'),
  rejected(2, 'rejected'),
  continueStage(3, 'continue_stage'),
  parentMeeting(4, 'parent_meeting'),
  parentExchangeNumbers(5, 'parent_exchange_numbers'),
  undefined(6, 'undefined');

  final int status;
  final String statusText;

  const UserRequestStatus(this.status, this.statusText);
}

extension CheckUserRequestStatus on UserRequestStatus{
  bool get isPending => this == UserRequestStatus.pending;
  bool get isAccepted => this == UserRequestStatus.accepted;
  bool get isRejected => this == UserRequestStatus.rejected;
  bool get isContinueStage => this == UserRequestStatus.continueStage;
  bool get isParentMeeting => this == UserRequestStatus.parentMeeting;
  bool get isParentExchangeNumbers => this == UserRequestStatus.parentExchangeNumbers;
  bool get isUndefined => this == UserRequestStatus.undefined;
}

enum ChatStages{
  newChat(0, 'new'),
  shariaComplaintMeeting(1, 'sharia_complaint_meeting'),
  istikharah(2, 'istikharah'),
  informParents(3, 'inform_parents'),
  engagement(4, 'engagement'),
  individualParent(5, 'individual_parent');

  final int stage;
  final String stageText;

  const ChatStages(this.stage, this.stageText);
}

extension CheckChatStages on ChatStages{
  bool get isNewChat =>  this == ChatStages.newChat;
  bool get isShariaComplaintMeeting => this == ChatStages.shariaComplaintMeeting;
  bool get isIstirah => this == ChatStages.istikharah;
  bool get isInformParents => this == ChatStages.informParents;
  bool get isEngagement => this == ChatStages.engagement;
  bool get isIndividualParent => this == ChatStages.individualParent;
}

enum MatchRequest{
  moveToNext(0, 'next_stage_request'),
  reject(2, 'reject_request'),
  extension(1, 'extension_request'),
  videoCall(3, 'video_call_request'),
  adminMeeting(4, 'admin_meeting_request'),
  parentMeeting(5, 'parent_meeting_request'),
  parentExchangeNumbers(6, 'parent_exchange_numbers'),
  parentIndividualApproval(7, 'parent_individual_approval');


  final int id;
  final String requestName;
  const MatchRequest(this.id, this.requestName);
}

extension CheckMatchRequest on MatchRequest{
  bool get isMoveToNext => this == MatchRequest.moveToNext;
  bool get isReject => this == MatchRequest.reject;
  bool get isExtension => this == MatchRequest.extension;
  bool get isVideoCall => this == MatchRequest.videoCall;
  bool get isAdminMeeting => this == MatchRequest.adminMeeting;
  bool get isParentMeeting => this == MatchRequest.parentMeeting;
  bool get isParentExchangeNumbers => this == MatchRequest.parentExchangeNumbers;
  bool get isParentIndividualApproval => this == MatchRequest.parentIndividualApproval;
}