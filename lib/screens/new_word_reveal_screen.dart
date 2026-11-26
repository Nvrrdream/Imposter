import 'package:material_ui/material_ui.dart';
import 'round_back_scope.dart';

import '../data/word_bank.dart';
import '../models/game_state.dart';
import '../models/player_assignment.dart';
import '../services/game_session_controller.dart';
import 'discussion_screen.dart';

class NewWordRevealScreen extends StatefulWidget {
  const NewWordRevealScreen({
    required this.gameState,
    required this.sessionController,
    super.key,
  });

  final GameState gameState;
  final GameSessionController sessionController;

  @override
  State<NewWordRevealScreen> createState() => _NewWordRevealScreenState();
}

class _NewWordRevealScreenState extends State<NewWordRevealScreen> {
  late final List<PlayerAssignment> _assignments;
  late final GameState _updatedGameState;

  int _currentPlayerIndex = 0;
  bool _isRevealed = false;
  bool _hasRevealedCurrentPlayer = false;

  @override
  void initState() {
    super.initState();

    String? previousWord;

    for (final assignment in widget.gameState.activeAssignments) {
      if (!assignment.isImposter && assignment.secretWord != null) {
        previousWord = assignment.secretWord;
        break;
      }
    }

    final wordEntry = WordBank.pickRandom(
      difficulty: widget.gameState.difficulty,
      excludeWord: previousWord,
    );

    _assignments = List.unmodifiable(
      widget.gameState.activeAssignments.map((assignment) {
        if (assignment.isImposter) {
          return PlayerAssignment(
            playerName: assignment.playerName,
            isImposter: true,
            category: wordEntry.lowerCategory,
          );
        }

        return PlayerAssignment(
          playerName: assignment.playerName,
          isImposter: false,
          secretWord: wordEntry.word,
        );
      }),
    );

    _updatedGameState = GameState(
      allAssignments: widget.gameState.allAssignments,
      activeAssignments: _assignments,
      eliminatedAssignments: widget.gameState.eliminatedAssignments,
      wrongVotes: widget.gameState.wrongVotes,
      roundsCompleted: widget.gameState.roundsCompleted,
      status: widget.gameState.status,
      difficulty: widget.gameState.difficulty,
      newWordEveryRound: widget.gameState.newWordEveryRound,
      impostersKnowEachOther: widget.gameState.impostersKnowEachOther,
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

    if (_currentPlayerIndex >= _assignments.length) {
      return DiscussionScreen(
        gameState: _updatedGameState,
        sessionController: widget.sessionController,
      );
    }

    final assignment = _assignments[_currentPlayerIndex];

    final fellowImposterNames =
        widget.gameState.impostersKnowEachOther && assignment.isImposter
            ? _assignments
                .where(
                  (player) =>
                      player.isImposter &&
                      player.playerName != assignment.playerName,
                )
                .map((player) => player.playerName)
                .toList(growable: false)
            : const <String>[];

    return RoundBackScope(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('New Round'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ROUND ${widget.gameState.currentRound}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.secondary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Press and hold to reveal your new information',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
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
                                                    ? 'YOUR CATEGORY'
                                                    : 'YOUR NEW WORD',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              if (fellowImposterNames
                                                  .isNotEmpty) ...[
                                                const SizedBox(height: 24),
                                                Text(
                                                  'YOUR PARTNERS',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        color: colors
                                                            .onSurfaceVariant,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.2,
                                                      ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  fellowImposterNames.join(', '),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        color: colors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        'Release to hide your information',
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
    ),
    );
  }
}