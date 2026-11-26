
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
    final state = voteResult.state;
    final eliminatedPlayer = voteResult.eliminatedPlayer;

    final wasImposterCaught = voteResult.wasImposterCaught;
    final isGameFinished = state.isFinished;

    final initialImposterCount =
        state.allAssignments.where((player) => player.isImposter).length;

    final isMultiImposter = initialImposterCount > 1;

    final String characterAsset;

    if (isMultiImposter) {
      if (isGameFinished) {
        characterAsset = wasImposterCaught
            ? 'assets/images/vote_results/multi_imposters_caught.webp'
            : 'assets/images/vote_results/multi_imposters_win.webp';
      } else {
        characterAsset = wasImposterCaught
            ? 'assets/images/vote_results/imposter_caught_intermediate.webp'
            : 'assets/images/vote_results/multi_innocent_eliminated.webp';
      }
    } else {
      characterAsset = wasImposterCaught
          ? 'assets/images/vote_results/single_imposter_caught.webp'
          : 'assets/images/vote_results/single_imposter_win.webp';
    }

    final title = wasImposterCaught
        ? 'IMPOSTER BUSTED!'
        : isGameFinished
            ? 'IMPOSTERS WIN!'
            : 'INNOCENT ELIMINATED';

    final message = wasImposterCaught
        ? '${eliminatedPlayer.playerName} was an imposter!'
        : '${eliminatedPlayer.playerName} was innocent.';

    const backgroundColor = Color(0xFF191516);

    return RoundBackScope(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Vote Result'),
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    characterAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!isGameFinished) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${state.remainingImposters} imposters remain.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                const SizedBox(height: 20),
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
