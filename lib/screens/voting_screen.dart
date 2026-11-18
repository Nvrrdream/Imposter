
import 'package:material_ui/material_ui.dart';

import '../models/game_state.dart';
import '../services/game_state_service.dart';
import 'vote_reveal_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({
    required this.gameState,
    super.key,
  });

  final GameState gameState;

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  String? _selectedPlayer;

  void _confirmVote() {
    if (_selectedPlayer == null) return;

    final result = GameStateService.processVote(
      state: widget.gameState,
      votedPlayerName: _selectedPlayer!,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VoteRevealScreen(
          voteResult: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final players = widget.gameState.activeAssignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WHO IS THE IMPOSTER?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the one player your group suspects.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: players.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final player = players[index].playerName;
                    final isSelected = _selectedPlayer == player;

                    return Card(
                      color: isSelected ? colors.secondary : null,
                      child: ListTile(
                        title: Text(
                          player,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? colors.onSecondary : null,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedPlayer = player;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _selectedPlayer == null ? null : _confirmVote,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Confirm vote'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
