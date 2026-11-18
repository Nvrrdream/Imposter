
import 'player_assignment.dart';

enum GameStatus {
  playing,
  innocentTeamWon,
  impostersWon,
}

class GameState {
  GameState({
    required List<PlayerAssignment> allAssignments,
    required List<PlayerAssignment> activeAssignments,
    required List<PlayerAssignment> eliminatedAssignments,
    required this.wrongVotes,
    required this.roundsCompleted,
    required this.status,
  })  : allAssignments = List.unmodifiable(allAssignments),
        activeAssignments = List.unmodifiable(activeAssignments),
        eliminatedAssignments = List.unmodifiable(eliminatedAssignments);

  factory GameState.initial(List<PlayerAssignment> assignments) {
    return GameState(
      allAssignments: assignments,
      activeAssignments: assignments,
      eliminatedAssignments: const [],
      wrongVotes: 0,
      roundsCompleted: 0,
      status: GameStatus.playing,
    );
  }

  final List<PlayerAssignment> allAssignments;
  final List<PlayerAssignment> activeAssignments;
  final List<PlayerAssignment> eliminatedAssignments;

  final int wrongVotes;
  final int roundsCompleted;
  final GameStatus status;

  int get remainingImposters {
    return activeAssignments.where((player) => player.isImposter).length;
  }

  int get currentRound => roundsCompleted + 1;

  bool get isFinished => status != GameStatus.playing;
}
