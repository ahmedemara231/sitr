import '../../features/chats/enums.dart';

extension Convert on int{
  ChatStages get getCurrentStageAsStagesEnum => ChatStages.values
      .firstWhere((e) => this == e.stage);

  MatchRequestEnum get getMatchRequest => MatchRequestEnum.values
      .firstWhere((e) => this == e.id);
}