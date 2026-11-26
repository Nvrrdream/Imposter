
import 'package:material_ui/material_ui.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Icon(
              Icons.auto_stories_rounded,
              size: 58,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'TRUST NO ONE',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find the imposter before they figure out your secret word.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 28),
            _StepCard(
              number: '01',
              icon: Icons.people_rounded,
              title: 'SET UP PLAYERS',
              description:
                  'Add 3–12 players. Choose how many imposters will participate. You can enable multiple imposters in Settings.',
            ),
            _StepCard(
              number: '02',
              icon: Icons.visibility_rounded,
              title: 'REVEAL YOUR ROLE',
              description:
                  'Pass the phone around. Each player presses and holds the card to privately reveal their role. Innocent players receive a secret word. Imposters receive a category and a hint.',
            ),
            _StepCard(
              number: '03',
              icon: Icons.forum_rounded,
              title: 'DISCUSSION TIME',
              description:
                  'Take turns giving clues about the secret word. Innocent players should demonstrate that they know the word without directly revealing it. Imposters must blend in.',
            ),
            _StepCard(
              number: '04',
              icon: Icons.how_to_vote_rounded,
              title: 'CAST YOUR VOTE',
              description:
                  'Discuss your suspicions and agree on one player to eliminate. Select that player on the voting screen and confirm your vote.',
            ),
            _StepCard(
              number: '05',
              icon: Icons.manage_search_rounded,
              title: 'THE REVEAL',
              description:
                  'The eliminated player’s role is revealed. If an imposter is caught, the remaining players continue. If an innocent player is eliminated, the imposters get closer to winning.',
            ),
            const SizedBox(height: 16),
            Text(
              'HOW TO WIN',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INNOCENT TEAM',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Find and eliminate every imposter to win.',
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'IMPOSTERS',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Win when the number of incorrect eliminations reaches the number of imposters still remaining.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SCORING',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Each player on the winning team receives 1 point.',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Points accumulate across games in the same session. Choose NEXT GAME to continue with the same scoreboard.',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Observe carefully. Question everything.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: colors.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  number,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
