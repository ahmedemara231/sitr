import '../../features/chats/enums.dart';

extension Convert on int{
  ChatStages get getCurrentStageAsStagesEnum => ChatStages.values
      .firstWhere((e) => this == e.stage);

  MatchRequest get getMatchRequest => MatchRequest.values
      .firstWhere((e) => this == e.id);
}