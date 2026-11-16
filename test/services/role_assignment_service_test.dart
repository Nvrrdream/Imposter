import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/data/word_bank.dart';
import 'package:imposter/services/role_assignment_service.dart';

void main() {
  group('RoleAssignmentService', () {
    const players = [
      'Player 1',
      'Player 2',
      'Player 3',
      'Player 4',
      'Player 5',
    ];

    final wordEntry = WordBank.entries.first;

    test('assigns the requested number of imposters', () {
      final assignments = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(10),
      );

      final imposters = assignments.where((player) => player.isImposter);

      expect(imposters.length, 2);
    });

    test('normal players receive only the secret word', () {
      final assignments = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(10),
      );

      final normalPlayers = assignments.where((player) => !player.isImposter);

      for (final player in normalPlayers) {
        expect(player.secretWord, wordEntry.word);
        expect(player.category, isNull);
        expect(player.hint, isNull);
      }
    });

    test('imposters receive the same category and hint, not the word', () {
      final assignments = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(10),
      );

      final imposters = assignments.where((player) => player.isImposter);

      for (final player in imposters) {
        expect(player.secretWord, isNull);
        expect(player.category, wordEntry.category);
        expect(player.hint, wordEntry.hint);
      }
    });

    test('preserves player order and names', () {
      final assignments = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(10),
      );

      expect(
        assignments.map((player) => player.playerName).toList(),
        players,
      );
    });

    test('produces the same assignment with the same random seed', () {
      final first = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(42),
      );

      final second = RoleAssignmentService.assign(
        players: players,
        imposterCount: 2,
        wordEntry: wordEntry,
        random: Random(42),
      );

      expect(
        first.map((player) => player.isImposter).toList(),
        second.map((player) => player.isImposter).toList(),
      );
    });

    test('rejects invalid imposter counts', () {
      expect(
        () => RoleAssignmentService.assign(
          players: players,
          imposterCount: 0,
          wordEntry: wordEntry,
        ),
        throwsArgumentError,
      );

      expect(
        () => RoleAssignmentService.assign(
          players: players,
          imposterCount: players.length,
          wordEntry: wordEntry,
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate player names', () {
      expect(
        () => RoleAssignmentService.assign(
          players: ['Alex', 'alex', 'Jordan'],
          imposterCount: 1,
          wordEntry: wordEntry,
        ),
        throwsArgumentError,
      );
    });
  });
}