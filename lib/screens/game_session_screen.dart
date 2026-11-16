import 'package:material_ui/material_ui.dart';

import '../data/word_bank.dart';
import '../models/player_assignment.dart';
import '../services/role_assignment_service.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({
    required this.players,
    required this.imposterCount,
    super.key,
  });

  final List<String> players;
  final int imposterCount;

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
  late final List<PlayerAssignment> _assignments;
  int _currentPlayerIndex = 0;
  bool _isReady = false;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();

    final wordEntry = WordBank.pickRandom();

    _assignments = List.unmodifiable(
      RoleAssignmentService.assign(
        players: widget.players,
        imposterCount: widget.imposterCount,
        wordEntry: wordEntry,
      ),
    );
  }

  void _startReveal() {
    setState(() {
      _isReady = true;
      _isRevealed = false;
    });
  }

  void _revealRole() {
    setState(() {
      _isRevealed = true;
    });
  }

  void _finishTurn() {
    setState(() {
      _isRevealed = false;
      _isReady = false;
      _currentPlayerIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFinished = _currentPlayerIndex >= _assignments.length;

    if (isFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Round Ready'),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.groups_rounded,
                    size: 64,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'EVERYONE IS READY',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'All players have received their roles. '
                    'The discussion can begin.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back to Home'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final assignment = _assignments[_currentPlayerIndex];

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
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isReady) ...[
                              const Icon(
                                Icons.phone_android_rounded,
                                size: 56,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'PASS THE PHONE TO',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: colors.secondary,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                assignment.playerName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Make sure nobody else can see the screen.',
                                textAlign: TextAlign.center,
                              ),
                            ] else if (!_isRevealed) ...[
                              const Icon(
                                Icons.visibility_off_rounded,
                                size: 56,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                assignment.playerName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Your role is hidden. Tap below when you are ready to view it.',
                                textAlign: TextAlign.center,
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
                              const Text(
                                'Remember your information. Do not show it to anyone.',
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: !_isReady
                      ? _startReveal
                      : !_isRevealed
                          ? _revealRole
                          : _finishTurn,
                  child: Text(
                    !_isReady
                        ? "I'm ready"
                        : !_isRevealed
                            ? 'Reveal my role'
                            : 'Got it',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}