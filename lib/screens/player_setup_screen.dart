
import 'package:material_ui/material_ui.dart';

import 'game_session_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _players = [];
  int _imposterCount = 1;


  @override
  void initState() {
    super.initState();

    for (var i = 1; i <= 3; i++) {
      _players.add(TextEditingController(text: 'Player $i'));
    }
  }

  @override
  void dispose() {
    for (final player in _players) {
      player.dispose();
    }

    super.dispose();
  }

  void _addPlayer() {
    if (_players.length >= 12) return;

    setState(() {
      _players.add(
        TextEditingController(text: 'Player ${_players.length + 1}'),
      );
    });
  }

  void _removePlayer(int index) {
    if (_players.length <= 3 || index != _players.length - 1) return;

    setState(() {
      _players[index].dispose();
      _players.removeAt(index);

      if (_imposterCount > _players.length - 1) {
        _imposterCount = _players.length - 1;
      }
    });
  }

  void _continue() {
    final names = _players
        .map((player) => player.text.trim())
        .toList();

    if (names.length < 3 || names.length > 12) {
      _showMessage('There must be between 3 and 12 players.');
      return;
    }

    if (names.any((name) => name.isEmpty)) {
      _showMessage('Player names cannot be empty.');
      return;
    }

    final normalizedNames = names.map((name) => name.toLowerCase()).toSet();

    if (normalizedNames.length != names.length) {
      _showMessage('Player names must be unique.');
      return;
    }

    if (_imposterCount < 1 || _imposterCount >= names.length) {
      _showMessage('Invalid imposter count.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameSessionScreen(
          players: List<String>.unmodifiable(names),
          imposterCount: _imposterCount,
        ),
      ),
    );
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Setup'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'PLAYERS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.secondary,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add everyone who is playing.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_players.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: colors.primaryContainer,
                                foregroundColor: colors.onPrimaryContainer,
                                child: Text('${index + 1}'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _players[index],
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    hintText: 'Player name',
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove player',
                                onPressed: _players.length > 3 && index == _players.length - 1
                                    ? () => _removePlayer(index)
                                    : null,
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  OutlinedButton.icon(
                    onPressed: _players.length < 12 ? _addPlayer : null,
                    icon: const Icon(Icons.add),
                    label: Text(
                      _players.length < 12
                          ? 'Add player'
                          : 'Maximum players reached',
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'IMPOSTERS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.secondary,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose how many imposters will be in the game.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Imposter count',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            onPressed: _imposterCount > 1
                                ? () {
                                    setState(() => _imposterCount--);
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$_imposterCount',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: _imposterCount < _players.length - 1
                                ? () {
                                    setState(() => _imposterCount++);
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'At least one player must remain a normal player.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _continue,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Continue'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
