
import '../models/game_state.dart';

class ScoringService {
  static Map<String, int> calculatePoints({
    required GameState state,
  }) {
    if (!state.isFinished) {
      throw StateError('Cannot calculate points before the game ends.');
    }

    return {
      for (final player in state.allAssignments)
        player.playerName: switch (state.status) {
          GameStatus.impostersWon => player.isImposter ? 1 : 0,
          GameStatus.innocentTeamWon => player.isImposter ? 0 : 1,
          GameStatus.playing => 0,
        },
    };
  }
}
