
import 'package:material_ui/material_ui.dart';

import '../models/game_state.dart';
import '../services/scoring_service.dart';

class GameResultsScreen extends StatelessWidget {
  const GameResultsScreen({
    required this.gameState,
    super.key,
  });

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final points = ScoringService.calculatePoints(state: gameState);

    final winner = gameState.status == GameStatus.impostersWon
        ? 'IMPOSTERS WIN!'
        : 'INNOCENTS WIN!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
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
              const SizedBox(height: 32),
              Text(
                'POINTS AWARDED',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: gameState.allAssignments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final player = gameState.allAssignments[index];
                    final playerPoints = points[player.playerName] ?? 0;

                    return Card(
                      child: ListTile(
  title: Row(
  children: [
    Text(
      player.playerName,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
    if (player.isImposter) ...[
      const SizedBox(width: 8),
      Icon(
        Icons.circle,
        size: 9,
        color: colors.error,
      ),
    ],
  ],
),
                        trailing: Text(
                          playerPoints == 1 ? '+1 point' : '0 points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: playerPoints == 1
                                ? colors.primary
                                : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Back to home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
