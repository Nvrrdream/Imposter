import 'package:material_ui/material_ui.dart';

import 'game_results_screen.dart';
import '../services/game_state_service.dart';
import 'discussion_screen.dart';
import 'new_word_reveal_screen.dart';
class VoteRevealScreen extends StatelessWidget {
  const VoteRevealScreen({
    required this.voteResult,
    super.key,
  });

  final VoteResult voteResult;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = voteResult.state;
    final eliminatedPlayer = voteResult.eliminatedPlayer;

    final wasImposterCaught = voteResult.wasImposterCaught;
    final isGameFinished = state.isFinished;

    final title = wasImposterCaught
        ? 'IMPOSTER BUSTED!'
        : isGameFinished
            ? 'IMPOSTERS WIN!'
            : 'INNOCENT ELIMINATED';

    final message = wasImposterCaught
        ? '${eliminatedPlayer.playerName} was an imposter!'
        : '${eliminatedPlayer.playerName} was innocent.';

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
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (!isGameFinished)
                Text(
                  '${state.remainingImposters} imposters remain.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (isGameFinished) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => GameResultsScreen(
                          gameState: state,
                        ),
                      ),
                    );
                  } else {
                    final Widget nextScreen = state.newWordEveryRound
                        ? NewWordRevealScreen(gameState: state)
                        : DiscussionScreen(gameState: state);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => nextScreen,
                      ),
                      (route) => route.isFirst,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    isGameFinished ? 'Finish game' : 'Continue discussion',
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
