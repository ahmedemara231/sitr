import '../../core/network/api_endpoints.dart';

enum UserRequestStatus{
  pending(0, 'pending'),
  accepted(1, 'accepted'),
  rejected(2, 'rejected'),
  continueStage(3, 'continue_stage'),
  parentMeeting(4, 'parent_meeting'),
  undefined(6, 'undefined'),
  parentExchangeNumbers(7, 'parent_exchange_numbers');

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
  bool get isUndefined => this == UserRequestStatus.undefined;
  bool get isParentExchangeNumbers => this == UserRequestStatus.parentExchangeNumbers;
}

enum ChatStages{

  rejected(-2, 'rejected'),
  // full individual - DIRECT MATCH
  newChat(-1, 'new'),
  chatting(0, 'chatting'),
  shariaComplaintMeeting(1, 'sharia_complaint_meeting'),
  shariaMeetingChoice(2, 'sharia_meeting_choice'),
  istikharah(2, 'istikharah'),
  informParents(3, 'inform_parents'),

  // full parent - FULL PARENT MATCH
  fullParentConversation(8, 'full_parent_conversation'),
  parentsExchangeNumber(4, 'parent_exchange_numbers'),

  engagement(5, 'engagement'),


  // parent & individual - PARENT MATCH
  parentIndividualConversation(6, 'parent_individual_conversation'),
  completed(6, 'completed');

  final int stage;
  final String stageText;

  const ChatStages(this.stage, this.stageText);
}

extension CheckChatStages on ChatStages{
  bool get isNewChat =>  this == ChatStages.newChat;
  bool get isChatting =>  this == ChatStages.chatting;
  bool get isShariaComplaintMeeting => this == ChatStages.shariaComplaintMeeting;
  bool get isShariaMeetingChoice => this == ChatStages.shariaMeetingChoice;
  bool get isIstikharah => this == ChatStages.istikharah;
  bool get isInformParents => this == ChatStages.informParents;
  bool get isParentsExchangeNumber => this == ChatStages.parentsExchangeNumber;
  bool get isEngagement => this == ChatStages.engagement;
  bool get isFullParentConversation => this == ChatStages.fullParentConversation;
  bool get isParentIndividualConversation => this == ChatStages.parentIndividualConversation;
  bool get isRejected => this == ChatStages.rejected;
}


enum MatchRequestEnum{
  noRequests(-1, 'no_requests'),
  moveToNext(0, ApiConstants.userMoveToNextRequest),
  reject(2, ApiConstants.rejectRequest),
  extension(1, ApiConstants.userExtensionRequest),
  videoCall(3, ApiConstants.videoCallRequest),
  adminMeeting(4, ApiConstants.adminMeetingRequest),
  parentMeeting(5, ApiConstants.parentMeetingRequest),
  continueStageRequest(8, ApiConstants.continueStageRequest),

  parentIndividualApproval(7, 'parent_individual_approval'); // عشان التاني مش بيوافق علي حاجة


  final int id;
  final String requestName;
  const MatchRequestEnum(this.id, this.requestName);
}

extension CheckMatchRequest on MatchRequestEnum{
  bool get isNoRequests => this == MatchRequestEnum.noRequests;
  bool get isMoveToNext => this == MatchRequestEnum.moveToNext;
  bool get isReject => this == MatchRequestEnum.reject;
  bool get isExtension => this == MatchRequestEnum.extension;
  bool get isVideoCall => this == MatchRequestEnum.videoCall;
  bool get isAdminMeeting => this == MatchRequestEnum.adminMeeting;
  bool get isParentMeeting => this == MatchRequestEnum.parentMeeting;
  bool get isParentIndividualApproval => this == MatchRequestEnum.parentIndividualApproval;
}


enum ShowTips{
  noPage('no_page', ''),
  appStages('app_stages',ApiConstants.appStages),
  chattingStageTips('chatting_stage_tips',ApiConstants.chattingStageTips),
  shariaComplaintMeetingTips('sharia_complaint_meeting_tips',ApiConstants.shariaComplaintMeetingTips),
  shariaMeetingChoiceTips('sharia_meeting_choice_tips',ApiConstants.shariaComplaintMeetingTips),
  shariaComplaintMeetingTerms('sharia_complaint_meeting_terms',ApiConstants.shariaComplaintMeetingTerms),
  istikharahTips('istikhara_tips',ApiConstants.istikharaTips),
  istikharahReminder('istikhara_reminder',ApiConstants.istikharaReminder),
  istikharahDua('istikhara_dua',ApiConstants.istikharaDua),
  informParentsTips('inform_parents',ApiConstants.informParentsTips),
  engagementTips('engagement_tips', ApiConstants.engagementTips),
  parentIndividualConversationTips('parent_individual_conversation', ApiConstants.parentIndividualConversation);

  final String title;
  final String path;
  const ShowTips(this.title, this.path);
}

extension CheckShowTips on ShowTips{
  bool get isNoPage => this == ShowTips.noPage;
  bool get isChattingStageTips => this == ShowTips.chattingStageTips;
  bool get isShariaComplaintMeetingTips => this == ShowTips.shariaComplaintMeetingTips;
  bool get isIstikharahTips => this == ShowTips.istikharahTips;
  bool get isIstikharahReminder => this == ShowTips.istikharahReminder;
  bool get istIkharahDua => this == ShowTips.istikharahDua;
  bool get isShariaComplaintMeetingTerms => this == ShowTips.shariaComplaintMeetingTerms;
  bool get isInformParentsTips => this == ShowTips.informParentsTips;
  bool get isEngagementTips => this == ShowTips.engagementTips;
  bool get isParentIndividualConversationTips => this == ShowTips.parentIndividualConversationTips;
}

enum ShariaChoice {
  complete('complete'),
  skip('skip');

  final String value;
  const ShariaChoice(this.value);
}


