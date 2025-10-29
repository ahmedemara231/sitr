enum ChatStages{
  newChat(0, 'new'),
  islamicPerspectiveLook(1, 'islamicPerspectiveLook');

  final int stage;
  final String stageText;

  const ChatStages(this.stage, this.stageText);
}

extension CheckChatStages on ChatStages{
  bool get isNewChat =>  this == ChatStages.newChat;
}

enum MatchRequest{
  moveToNext(0, 'move_to_next_stage_request'),
  reject(2, 'reject_request'),
  extension(1, 'extension_request');

  final int id;
  final String requestName;
  const MatchRequest(this.id, this.requestName);
}

extension CheckMatchRequest on MatchRequest{
  bool get isMoveToNext => this == MatchRequest.moveToNext;
  bool get isReject => this == MatchRequest.reject;
  bool get isExtension => this == MatchRequest.extension;

}