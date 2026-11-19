
import '../models/game_state.dart';
import '../models/player_assignment.dart';

class VoteResult {
  const VoteResult({
    required this.state,
    required this.eliminatedPlayer,
  });

  final GameState state;
  final PlayerAssignment eliminatedPlayer;

  bool get wasImposterCaught => eliminatedPlayer.isImposter;
}

class GameStateService {
  static VoteResult processVote({
    required GameState state,
    required String votedPlayerName,
  }) {
    if (state.isFinished) {
      throw StateError('The game has already finished.');
    }

    final selectedPlayer = state.activeAssignments
        .where((player) => player.playerName == votedPlayerName)
        .firstOrNull;

    if (selectedPlayer == null) {
      throw StateError('Player is not available for voting.');
    }

    final remainingPlayers = state.activeAssignments
        .where((player) => player.playerName != votedPlayerName)
        .toList();

    final eliminatedPlayers = [
      ...state.eliminatedAssignments,
      selectedPlayer,
    ];

    final wrongVotes = state.wrongVotes +
        (selectedPlayer.isImposter ? 0 : 1);

    final remainingImposters =
        remainingPlayers.where((player) => player.isImposter).length;
        
    final GameStatus status;

    if (remainingImposters == 0) {
      status = GameStatus.innocentTeamWon;
    } else if (wrongVotes >= remainingImposters) {
      status = GameStatus.impostersWon;
    } else {
      status = GameStatus.playing;
    }

    final updatedState = GameState(
      allAssignments: state.allAssignments,
      activeAssignments: remainingPlayers,
      eliminatedAssignments: eliminatedPlayers,
      wrongVotes: wrongVotes,
      roundsCompleted: state.roundsCompleted + 1,
      status: status,
      difficulty: state.difficulty,
      newWordEveryRound: state.newWordEveryRound,
      impostersKnowEachOther: state.impostersKnowEachOther,
    );

    return VoteResult(
      state: updatedState,
      eliminatedPlayer: selectedPlayer,
    );
  }
}
