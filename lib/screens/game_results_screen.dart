
import 'package:material_ui/material_ui.dart';
import 'round_back_scope.dart';

import '../models/game_state.dart';
import '../services/game_session_controller.dart';
import 'game_session_screen.dart';

class GameResultsScreen extends StatefulWidget {
  const GameResultsScreen({
    required this.gameState,
    required this.sessionController,
    super.key,
  });

  final GameState gameState;
  final GameSessionController sessionController;

  @override
  State<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen> {
  late final Map<String, int> _cumulativeScores;

  @override
  void initState() {
    super.initState();

    widget.sessionController.recordGameResult(widget.gameState);
    _cumulativeScores = widget.sessionController.cumulativeScores;
  }

  void _startNextGame() {
    final nextGameState = widget.sessionController.startNextGame();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameSessionScreen(
          sessionController: widget.sessionController,
          gameState: nextGameState,
        ),
      ),
    );
  }

  void _exitSession() {
    RoundBackScope.exitToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final winner = widget.gameState.status == GameStatus.impostersWon
        ? 'IMPOSTERS WIN!'
        : 'INNOCENTS WIN!';

    final players = widget.sessionController.players;
    final imposterNames = widget.gameState.allAssignments
        .where((assignment) => assignment.isImposter)
        .map((assignment) => assignment.playerName)
        .toSet();

    return RoundBackScope(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Exit session',
            onPressed: _exitSession,
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Icon(
                Icons.emoji_events_rounded,
                size: 72,
                color: colors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                winner,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: ListView.separated(
                      itemCount: players.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final totalPoints = _cumulativeScores[player] ?? 0;
                        final isImposter = imposterNames.contains(player);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  player,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isImposter) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.visibility_rounded,
                                  color: colors.primary,
                                  size: 22,
                                ),
                              ],
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8DFD5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$totalPoints',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB52A3A),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _startNextGame,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('NEXT GAME'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
