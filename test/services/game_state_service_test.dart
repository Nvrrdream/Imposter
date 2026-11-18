
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/models/game_state.dart';
import 'package:imposter/models/player_assignment.dart';
import 'package:imposter/services/game_state_service.dart';

void main() {
  PlayerAssignment player(String name, {bool imposter = false}) {
    return PlayerAssignment(
      playerName: name,
      isImposter: imposter,
      secretWord: imposter ? null : 'Tiger',
      category: 'Animals',
      hint: 'A living creature',
    );
  }

  group('GameStateService', () {
    test('correct vote eliminates an imposter without increasing wrong votes', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ];

      final state = GameState.initial(assignments);

      final result = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      );

      expect(result.wasImposterCaught, isTrue);
      expect(result.state.activeAssignments.length, 2);
      expect(result.state.eliminatedAssignments.single.playerName, 'Alex');
      expect(result.state.wrongVotes, 0);
      expect(result.state.status, GameStatus.innocentTeamWon);
    });

    
    test('wrong vote eliminates an innocent and increases wrong votes', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
      ];

      final result = GameStateService.processVote(
        state: GameState.initial(assignments),
        votedPlayerName: 'Sam',
      );

      expect(result.wasImposterCaught, isFalse);
      expect(result.state.wrongVotes, 1);
      expect(result.state.activeAssignments.length, 3);
      expect(result.state.remainingImposters, 2);
      expect(result.state.status, GameStatus.playing);
    });


    test('imposters win when wrong votes reach remaining imposters', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
        player('Taylor'),
      ];

      var state = GameState.initial(assignments);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      ).state;

      expect(state.status, GameStatus.playing);
      expect(state.wrongVotes, 1);
      expect(state.remainingImposters, 2);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Jordan',
      ).state;

      expect(state.status, GameStatus.impostersWon);
      expect(state.wrongVotes, 2);
    });

    test('threshold adjusts after an imposter is caught', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
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
      final assignments = [
        player('Alex', imposter: true),
        player('Chris', imposter: true),
        player('Sam'),
        player('Jordan'),
      ];

      var state = GameState.initial(assignments);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Alex',
      ).state;

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Chris',
      ).state;

      expect(state.remainingImposters, 0);
      expect(state.status, GameStatus.innocentTeamWon);
    });

    test('eliminated players cannot be voted out again', () {
      final assignments = [
        player('Alex', imposter: true),
        player('Sam'),
        player('Chris'),
      ];

      var state = GameState.initial(assignments);

      state = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      ).state;

      expect(
        () => GameStateService.processVote(
          state: state,
          votedPlayerName: 'Sam',
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

      final state = GameState.initial(assignments);

      final result = GameStateService.processVote(
        state: state,
        votedPlayerName: 'Sam',
      );

      expect(result.state.allAssignments.length, 3);
      expect(
        result.state.allAssignments.map((player) => player.playerName),
        ['Alex', 'Sam', 'Chris'],
      );
    });

    test('cannot process another vote after the game ends', () {
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

      expect(
        () => GameStateService.processVote(
          state: state,
          votedPlayerName: 'Sam',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
