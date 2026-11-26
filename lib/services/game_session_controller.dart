
import 'dart:math';

import '../data/word_bank.dart';
import '../models/game_state.dart';
import '../models/player_assignment.dart';
import '../models/word_entry.dart';
import '../services/role_assignment_service.dart';
import '../services/scoring_service.dart';

class GameSessionController {
  GameSessionController({
    required List<String> players,
    required this.imposterCount,
    required this.impostersKnowEachOther,
    required this.newWordEveryRound,
    required this.difficulty,
    Random? random,
  })  : players = List.unmodifiable(players),
        _random = random ?? Random(),
        _scores = {
          for (final player in players) player: 0,
        } {
    if (players.length < 3 || players.length > 12) {
      throw ArgumentError('There must be between 3 and 12 players.');
    }

    if (imposterCount < 1 || imposterCount >= players.length) {
      throw ArgumentError('Invalid imposter count.');
    }

    if (players.map((name) => name.trim().toLowerCase()).toSet().length !=
        players.length) {
      throw ArgumentError('Player names must be unique.');
    }

    if (players.any((name) => name.trim().isEmpty)) {
      throw ArgumentError('Player names cannot be empty.');
    }
  }

  final List<String> players;
  final int imposterCount;
  final bool impostersKnowEachOther;
  final bool newWordEveryRound;
  final WordDifficulty difficulty;

  final Random _random;
  final Map<String, int> _scores;
  final List<Set<String>> _recentImposterHistory = [];

  bool _hasStartedGame = false;
  bool _hasRecordedResult = true;

  Map<String, int> get cumulativeScores => Map.unmodifiable(_scores);

  List<Set<String>> get recentImposterHistory =>
      List.unmodifiable(_recentImposterHistory);

  GameState startNextGame() {
    if (_hasStartedGame && !_hasRecordedResult) {
      throw StateError('The current game has not finished.');
    }

    final wordEntry = WordBank.pickRandom(
      difficulty: difficulty,
      random: _random,
    );

    final assignments = RoleAssignmentService.assign(
      players: players,
      imposterCount: imposterCount,
      wordEntry: wordEntry,
      random: _random,
      recentImposterHistory: _recentImposterHistory,
    );

    final imposterNames = assignments
        .where((player) => player.isImposter)
        .map((player) => player.playerName)
        .toSet();

    _recentImposterHistory.insert(0, Set.unmodifiable(imposterNames));

    if (_recentImposterHistory.length > 2) {
      _recentImposterHistory.removeLast();
    }

    _hasStartedGame = true;
    _hasRecordedResult = false;

    return GameState.initial(
      List<PlayerAssignment>.unmodifiable(assignments),
      difficulty: difficulty,
      newWordEveryRound: newWordEveryRound,
      impostersKnowEachOther: impostersKnowEachOther,
    );
  }

  Map<String, int> recordGameResult(GameState state) {
    if (!_hasStartedGame || _hasRecordedResult) {
      throw StateError('There is no unrecorded game result.');
    }

    if (!state.isFinished) {
      throw StateError('Cannot record an unfinished game.');
    }

    final points = ScoringService.calculatePoints(state: state);

    for (final entry in points.entries) {
      _scores[entry.key] = (_scores[entry.key] ?? 0) + entry.value;
    }

    _hasRecordedResult = true;

    return Map.unmodifiable(points);
  }
}
