enum ChatStages{
  newChat(0, 'new'),
  islamicPerspectiveLook(1, 'islamicPerspectiveLook');

  final int stage;
  final String stageText;

  const ChatStages(this.stage, this.stageText);
}

extension Check on ChatStages{
  bool get isNewChat =>  this == ChatStages.newChat;
}