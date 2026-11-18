
import 'package:material_ui/material_ui.dart';

import '../models/game_state.dart';
import 'voting_screen.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({
    required this.gameState,
    super.key,
  });

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.groups_rounded,
                size: 72,
                color: colors.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'DISCUSSION TIME',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '${gameState.activeAssignments.length} players remain.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'Discuss the clues, question each other, '
                'and decide who you think the imposter is.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VotingScreen(
                        gameState: gameState,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Start voting'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
