
import 'package:imposter/models/word_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/models/game_state.dart';
import 'package:imposter/services/game_session_controller.dart';
import 'package:imposter/services/game_state_service.dart';

void main() {
  group('GameSessionController', () {
    late GameSessionController controller;

    const players = [
      'Player 1',
      'Player 2',
      'Player 3',
      'Player 4',
      'Player 5',
    ];

    setUp(() {
      controller = GameSessionController(
        players: players,
        imposterCount: 1,
        impostersKnowEachOther: false,
        newWordEveryRound: false,
        difficulty: WordDifficulty.medium,
      );
    });

    GameState finishGame(GameState state) {
      final innocent = state.allAssignments.firstWhere(
        (player) => !player.isImposter,
      );

      return GameStateService.processVote(
        state: state,
        votedPlayerName: innocent.playerName,
      ).state;
    }

    test('initializes scores for every player', () {
      expect(
        controller.cumulativeScores,
        {for (final player in players) player: 0},
      );
    });

    test('retains the original roster and settings', () {
      expect(controller.players, players);
      expect(controller.imposterCount, 1);
      expect(controller.impostersKnowEachOther, false);
      expect(controller.newWordEveryRound, false);
      expect(controller.difficulty, WordDifficulty.medium);
    });

    test('starts a game with the configured players', () {
      final state = controller.startNextGame();

      expect(
        state.allAssignments.map((player) => player.playerName).toList(),
        players,
      );
      expect(state.remainingImposters, 1);
      expect(state.isFinished, false);
    });

    test('does not start another game before recording the result', () {
      controller.startNextGame();

      expect(
        () => controller.startNextGame(),
        throwsA(isA<StateError>()),
      );
    });

    test('records a finished game result', () {
      final state = controller.startNextGame();
      final finishedState = finishGame(state);

      final points = controller.recordGameResult(finishedState);

      expect(finishedState.status, GameStatus.impostersWon);
      expect(points.values.fold<int>(0, (sum, value) => sum + value), 1);
      expect(
        controller.cumulativeScores.values.fold<int>(
          0,
          (sum, value) => sum + value,
        ),
        1,
      );
    });

    test('does not record the same game twice', () {
      final state = controller.startNextGame();
      final finishedState = finishGame(state);

      controller.recordGameResult(finishedState);

      expect(
        () => controller.recordGameResult(finishedState),
        throwsA(isA<StateError>()),
      );
    });

    test('accumulates scores across consecutive games', () {
      for (var i = 0; i < 3; i++) {
        final state = controller.startNextGame();
        final finishedState = finishGame(state);
        controller.recordGameResult(finishedState);
      }

      final totalPoints = controller.cumulativeScores.values.fold<int>(
        0,
        (sum, value) => sum + value,
      );

      expect(totalPoints, 3);
    });

    test('retains only the two most recent imposter assignments', () {
      final firstGame = controller.startNextGame();
      controller.recordGameResult(finishGame(firstGame));

      final secondGame = controller.startNextGame();
      controller.recordGameResult(finishGame(secondGame));

      final thirdGame = controller.startNextGame();

      expect(controller.recentImposterHistory.length, 2);
      expect(
        controller.recentImposterHistory.first,
        thirdGame.allAssignments
            .where((player) => player.isImposter)
            .map((player) => player.playerName)
            .toSet(),
      );
      expect(
        controller.recentImposterHistory.last,
        secondGame.allAssignments
            .where((player) => player.isImposter)
            .map((player) => player.playerName)
            .toSet(),
      );
    });
  });
}
