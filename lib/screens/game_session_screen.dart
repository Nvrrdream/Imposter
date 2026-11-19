import '../models/word_entry.dart';
import 'package:material_ui/material_ui.dart';

import '../models/game_state.dart';
import 'discussion_screen.dart';
import '../data/word_bank.dart';
import '../models/player_assignment.dart';
import '../services/role_assignment_service.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({
    required this.players,
    required this.imposterCount,
    required this.impostersKnowEachOther,
    required this.newWordEveryRound,
    required this.difficulty,
    super.key,
  });

  final List<String> players;
  final int imposterCount;
  final bool impostersKnowEachOther;
  final bool newWordEveryRound;
  final WordDifficulty difficulty;

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
  late final List<PlayerAssignment> _assignments;
  late final GameState _gameState;
  int _currentPlayerIndex = 0;
  bool _isRevealed = false;
  bool _hasRevealedCurrentPlayer = false;

  @override
  void initState() {
    super.initState();
    final wordEntry = WordBank.pickRandom(difficulty: widget.difficulty);
    _assignments = List.unmodifiable(
      RoleAssignmentService.assign(
        players: widget.players,
        imposterCount: widget.imposterCount,
        wordEntry: wordEntry,
      ),
    );
    _gameState = GameState.initial(
      _assignments,
      difficulty: widget.difficulty,
      newWordEveryRound: widget.newWordEveryRound,
      impostersKnowEachOther: widget.impostersKnowEachOther,
    );
  }

  void _revealRole() {
    if (_isRevealed) return;

    setState(() {
      _isRevealed = true;
      _hasRevealedCurrentPlayer = true;
    });
  }

  void _concealRole() {
    if (!_isRevealed) return;

    setState(() {
      _isRevealed = false;
    });
  }

  void _finishTurn() {
    setState(() {
      _isRevealed = false;
      _hasRevealedCurrentPlayer = false;
      _currentPlayerIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFinished = _currentPlayerIndex >= _assignments.length;

    if (isFinished) {
  return DiscussionScreen(
    gameState: _gameState,
  );
}

    final assignment = _assignments[_currentPlayerIndex];

    final fellowImposterNames =
      widget.impostersKnowEachOther && assignment.isImposter
          ? _assignments
              .where((player) =>
                  player.isImposter && player.playerName != assignment.playerName)
              .map((player) => player.playerName)
              .toList(growable: false)
          : const <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Role'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PLAYER ${_currentPlayerIndex + 1} OF ${_assignments.length}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.secondary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) => _revealRole(),
                      onTapUp: (_) => _concealRole(),
                      onTapCancel: _concealRole,
                      child: AnimatedSlide(
                        offset: _isRevealed
                            ? const Offset(0, -0.025)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        child: AnimatedScale(
                          scale: _isRevealed ? 1.015 : 1,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,

child: Card(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      minHeight: 300,
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isRevealed) ...[
                    const Icon(
                      Icons.lock_rounded,
                      size: 56,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      assignment.playerName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontSize: 30,
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Press and hold to reveal your role',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ] else ...[
                    Icon(
                      assignment.isImposter
                          ? Icons.visibility_rounded
                          : Icons.check_circle_rounded,
                      size: 56,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      assignment.isImposter
                          ? 'YOU ARE AN IMPOSTER'
                          : 'YOUR SECRET WORD',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      assignment.isImposter
                          ? assignment.category!
                          : assignment.secretWord!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (assignment.isImposter) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Hint: ${assignment.hint!}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (fellowImposterNames.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'YOUR PARTNERS',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fellowImposterNames.join(', '),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          if (_isRevealed) ...[
            const SizedBox(height: 16),
            const Text(
              'Release to hide your word',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    ),
  ),
),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_hasRevealedCurrentPlayer)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _finishTurn,
                    child: const Text('Got it'),
                  ),
                )
              else
                const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
