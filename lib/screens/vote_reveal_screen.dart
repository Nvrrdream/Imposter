import 'package:material_ui/material_ui.dart';
import 'round_back_scope.dart';

import '../services/game_session_controller.dart';
import '../services/game_state_service.dart';
import 'discussion_screen.dart';
import 'game_results_screen.dart';
import 'new_word_reveal_screen.dart';

class VoteRevealScreen extends StatelessWidget {
  const VoteRevealScreen({
    required this.voteResult,
    required this.sessionController,
    super.key,
  });

  final VoteResult voteResult;
  final GameSessionController sessionController;

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

    return RoundBackScope(
      child: Scaffold(
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
                          sessionController: sessionController,
                        ),
                      ),
                    );
                  } else {
                    final Widget nextScreen = state.newWordEveryRound
                        ? NewWordRevealScreen(
                            gameState: state,
                            sessionController: sessionController,
                          )
                        : DiscussionScreen(
                            gameState: state,
                            sessionController: sessionController,
                          );

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
    ),
    );
  }
}
