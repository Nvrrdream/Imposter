
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/models/game_state.dart';
import 'package:imposter/models/player_assignment.dart';
import 'package:imposter/services/game_state_service.dart';
import 'package:imposter/services/scoring_service.dart';

void main() {
  PlayerAssignment player(String name, {bool imposter = false}) {
    return PlayerAssignment(
      playerName: name,
      isImposter: imposter,
    );
  }

  group('ScoringService', () {
    test('awards every imposter a point when imposters win', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
        player('Taylor'),
        player('Morgan'),
      ];

      var state = GameState.initial(assignments);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      ).state;

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      ).state;
      
      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Jordan',
      ).state;

      final points = ScoringService.calculatePoints(state: state);

      expect(state.status, GameStatus.impostersWon);
      expect(points['Alex'], 1);
      expect(points['Chris'], 1);
      expect(points['Sam'], 0);
      expect(points['Jordan'], 0);
      expect(points['Taylor'], 0);
      expect(points['Morgan'], 0);
    });

    test('awards every innocent a point when innocent team wins', () {
  final assignments = [
    player('Alex', imposter: true),
    player('Chris', imposter: true),
    player('Sam'),
    player('Jordan'),
    player('Taylor'),
  ];

  final state = GameState(
    allAssignments: assignments,
    activeAssignments: [
      player('Taylor'),
    ],
    eliminatedAssignments: [
      player('Alex', imposter: true),
      player('Chris', imposter: true),
      player('Sam'),
      player('Jordan'),
    ],
    wrongVotes: 1,
    roundsCompleted: 4,
    status: GameStatus.innocentTeamWon,
  );

  final points = ScoringService.calculatePoints(state: state);

  expect(points['Alex'], 0);
  expect(points['Chris'], 0);
  expect(points['Sam'], 1);
  expect(points['Jordan'], 1);
  expect(points['Taylor'], 1);
});
  });
}
