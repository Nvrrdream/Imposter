import 'dart:math';

import '../models/player_assignment.dart';
import '../models/word_entry.dart';

class RoleAssignmentService {
  static List<PlayerAssignment> assign({
    required List<String> players,
    required int imposterCount,
    required WordEntry wordEntry,
    Random? random,
    List<Set<String>> recentImposterHistory = const [],
  }) {
    if (players.length < 3 || players.length > 12) {
      throw ArgumentError('There must be between 3 and 12 players.');
    }

    if (imposterCount < 1 || imposterCount >= players.length) {
      throw ArgumentError('Invalid imposter count.');
    }

    final normalizedNames = players
        .map((name) => name.trim().toLowerCase())
        .toSet();

    if (players.any((name) => name.trim().isEmpty)) {
      throw ArgumentError('Player names cannot be empty.');
    }

    if (normalizedNames.length != players.length) {
      throw ArgumentError('Player names must be unique.');
    }

    final source = random ?? Random();

    final recentGames = recentImposterHistory.take(2).toList();

    final repeatedlySelectedImposters = recentGames.length == 2
        ? recentGames[0]
            .map((name) => name.trim().toLowerCase())
            .toSet()
            .intersection(
              recentGames[1]
                  .map((name) => name.trim().toLowerCase())
                  .toSet(),
            )
        : <String>{};

    var eligibleIndexes = List<int>.generate(
      players.length,
      (index) => index,
    ).where(
      (index) => !repeatedlySelectedImposters.contains(
        players[index].trim().toLowerCase(),
      ),
    ).toList();

    if (eligibleIndexes.length < imposterCount) {
      eligibleIndexes = List<int>.generate(
        players.length,
        (index) => index,
      );
    }

    eligibleIndexes.shuffle(source);

    final selectedImposters = eligibleIndexes
        .take(imposterCount)
        .toSet();

    return List<PlayerAssignment>.generate(players.length, (index) {
      final isImposter = selectedImposters.contains(index);

      if (isImposter) {
        return PlayerAssignment(
          playerName: players[index],
          isImposter: true,
          category: wordEntry.category,
          hint: wordEntry.hint,
        );
      }

      return PlayerAssignment(
        playerName: players[index],
        isImposter: false,
        secretWord: wordEntry.word,
      );
    });
  }
}