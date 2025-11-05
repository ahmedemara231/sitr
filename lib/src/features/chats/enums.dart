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
  newChat(-1, 'new'),
  chatting(0, 'chatting'),
  shariaComplaintMeeting(1, 'sharia_complaint_meeting'),
  istikharah(2, 'istikharah'),
  informParents(3, 'inform_parents'),
  engagement(4, 'engagement'),
  individualParent(5, 'individual_parent'),
  rejected(6, 'rejected');

  final int stage;
  final String stageText;

  const ChatStages(this.stage, this.stageText);
}

extension CheckChatStages on ChatStages{
  bool get isNewChat =>  this == ChatStages.newChat;
  bool get isChatting =>  this == ChatStages.chatting;
  bool get isShariaComplaintMeeting => this == ChatStages.shariaComplaintMeeting;
  bool get isIstikharah => this == ChatStages.istikharah;
  bool get isInformParents => this == ChatStages.informParents;
  bool get isEngagement => this == ChatStages.engagement;
  bool get isIndividualParent => this == ChatStages.individualParent;
}

enum MatchRequestEnum{
  noRequests(-1, 'no_requests'),
  moveToNext(0, 'next_stage_request'),
  reject(2, 'reject_request'),
  extension(1, 'extension_request'),
  videoCall(3, 'video_call_request'),
  adminMeeting(4, 'admin_meeting_request'),
  parentMeeting(5, 'parent_meeting_request'),
  parentExchangeNumbers(6, 'parent_exchange_numbers'),
  parentIndividualApproval(7, 'parent_individual_approval'),
  continueStageRequest(8, 'continue_stage_request');

  final int id;
  final String requestName;
  const MatchRequestEnum(this.id, this.requestName);
}

extension CheckMatchRequest on MatchRequestEnum{
  bool get isMoveToNext => this == MatchRequestEnum.moveToNext;
  bool get isReject => this == MatchRequestEnum.reject;
  bool get isExtension => this == MatchRequestEnum.extension;
  bool get isVideoCall => this == MatchRequestEnum.videoCall;
  bool get isAdminMeeting => this == MatchRequestEnum.adminMeeting;
  bool get isParentMeeting => this == MatchRequestEnum.parentMeeting;
  bool get isParentExchangeNumbers => this == MatchRequestEnum.parentExchangeNumbers;
  bool get isParentIndividualApproval => this == MatchRequestEnum.parentIndividualApproval;
}