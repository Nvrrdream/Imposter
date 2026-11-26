import 'package:material_ui/material_ui.dart';

import '../models/game_state.dart';
import '../models/player_assignment.dart';
import '../services/game_session_controller.dart';
import 'discussion_screen.dart';
import 'round_back_scope.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({
    required this.sessionController,
    required this.gameState,
    super.key,
  });

  final GameSessionController sessionController;
  final GameState gameState;

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
    _gameState = widget.gameState;
    _assignments = _gameState.allAssignments;
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
        sessionController: widget.sessionController,
      );
    }

    final assignment = _assignments[_currentPlayerIndex];

    final fellowImposterNames =
        _gameState.impostersKnowEachOther && assignment.isImposter
        ? _assignments
              .where(
                (player) =>
                    player.isImposter &&
                    player.playerName != assignment.playerName,
              )
              .map((player) => player.playerName)
              .toList(growable: false)
        : const <String>[];

    final characterAsset = _isRevealed && assignment.isImposter
        ? 'assets/images/characters/hooded_imposter.webp'
        : 'assets/images/characters/hooded_innocent.webp';

    return RoundBackScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Private Role'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'PLAYER ${_currentPlayerIndex + 1} OF ${_assignments.length}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.secondary,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 380,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colors.surface,
                                      Color.lerp(
                                        colors.surface,
                                        colors.primary,
                                        _isRevealed && assignment.isImposter
                                            ? 0.16
                                            : 0.045,
                                      )!,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        child: Image.asset(
                                          characterAsset,
                                          key: ValueKey(characterAsset),
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Icon(
                                                Icons.person_outline_rounded,
                                                size: 120,
                                                color: colors.secondary,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (!_isRevealed) ...[
                                      Text(
                                        assignment.playerName,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontSize: 28,
                                              color: colors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lock_rounded,
                                            size: 18,
                                            color: colors.secondary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'PRESS AND HOLD TO REVEAL',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: colors.secondary,
                                                  letterSpacing: 1,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
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
                                              letterSpacing: 1.2,
                                              color: assignment.isImposter
                                                  ? colors.primary
                                                  : colors.secondary,
                                            ),
                                      ),
                                      const SizedBox(height: 14),
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
                                        const SizedBox(height: 12),
                                        Text(
                                          'Hint: ${assignment.hint!}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: colors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                      if (fellowImposterNames.isNotEmpty) ...[
                                        const SizedBox(height: 18),
                                        Text(
                                          'YOUR PARTNERS',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: colors.onSurfaceVariant,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          fellowImposterNames.join(', '),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Text(
                                        'Release to hide your role',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: colors.onSurfaceVariant,
                                            ),
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
                const SizedBox(height: 18),
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
