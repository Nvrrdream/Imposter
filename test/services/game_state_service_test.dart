
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/models/game_state.dart';
import 'package:imposter/models/player_assignment.dart';
import 'package:imposter/services/game_state_service.dart';

void main() {
  PlayerAssignment player(String name, {bool imposter = false}) {
    return PlayerAssignment(
      playerName: name,
      isImposter: imposter,
    );
  }

  group('GameStateService', () {
    test('correct vote eliminates an imposter without wrong votes', () {
      final state = GameState.initial([
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ]);

      final result = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      );

      expect(result.wasImposterCaught, isTrue);
      expect(result.state.wrongVotes, 0);
      expect(result.state.remainingImposters, 0);
      expect(result.state.status, GameStatus.innocentTeamWon);
    });

    test('wrong vote eliminates an innocent and increments wrongVotes', () {
      final state = GameState.initial([
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
      ]);

      final result = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      );

      expect(result.wasImposterCaught, isFalse);
      expect(result.state.wrongVotes, 1);
      expect(result.state.status, GameStatus.playing);
    });

    test('imposters win when wrong votes reach remaining imposters', () {
      final state = GameState.initial([
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ]);

      final result = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      );

      expect(result.state.wrongVotes, 1);
      expect(result.state.remainingImposters, 1);
      expect(result.state.status, GameStatus.impostersWon);
    });

    test('threshold adjusts after an imposter is caught', () {
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

      expect(state.status, GameStatus.playing);
      expect(state.remainingImposters, 1);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      ).state;

      expect(state.status, GameStatus.impostersWon);
      expect(state.wrongVotes, 1);
    });

    test('innocent team wins when all imposters are caught', () {
      var state = GameState.initial([
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
        player('Taylor'),
      ]);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      ).state;

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Chris',
      ).state;

      expect(state.status, GameStatus.innocentTeamWon);
      expect(state.remainingImposters, 0);
    });

    test('eliminated player cannot be voted again', () {
      var state = GameState.initial([
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ]);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      ).state;

      expect(
        () => GameStateService.processVote(
          state: state,
          votedPlayerName: 'Alex',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('original roster remains unchanged after eliminations', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ];

      var state = GameState.initial(assignments);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      ).state;

      expect(state.allAssignments.length, 3);
      expect(state.activeAssignments.length, 2);
      expect(state.eliminatedAssignments.length, 1);
    });

    test('cannot vote after game ends', () {
      var state = GameState.initial([
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ]);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      ).state;

      expect(
        () => GameStateService.processVote(
          state: state,
          votedPlayerName: 'Chris',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
