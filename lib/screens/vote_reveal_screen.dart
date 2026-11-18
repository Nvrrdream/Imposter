import 'package:material_ui/material_ui.dart';

import '../models/player_assignment.dart';

class VoteRevealScreen extends StatelessWidget {
  const VoteRevealScreen({
    required this.assignments,
    required this.selectedAssignment,
    super.key,
  });

  final List<PlayerAssignment> assignments;
  final PlayerAssignment selectedAssignment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final wasImposterCaught = selectedAssignment.isImposter;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote Result'),
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
                wasImposterCaught
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 80,
                color: colors.primary,
              ),
              const SizedBox(height: 32),
              Text(
                wasImposterCaught ? 'IMPOSTER BUSTED!' : 'IMPOSTER WINS!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                wasImposterCaught
                    ? '${selectedAssignment.playerName} was the imposter!'
                    : '${selectedAssignment.playerName} was innocent.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Finish game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}