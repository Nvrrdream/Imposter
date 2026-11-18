import 'package:material_ui/material_ui.dart';

import '../models/player_assignment.dart';
import 'voting_screen.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({
    required this.assignments,
    super.key,
  });

  final List<PlayerAssignment> assignments;

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
                'All ${assignments.length} players have received their roles.',
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
                        assignments: assignments,
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