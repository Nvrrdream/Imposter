import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/word_bank.dart';
import '../models/word_entry.dart';
import 'game_session_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _players = [];
  int _imposterCount = 1;
  bool _multiImposterMode = false;
  bool _impostersKnowEachOther = false;
  bool _newWordEveryRound = false;
  WordDifficulty _difficulty = WordDifficulty.medium;
  bool _isPreferenceLoaded = false;

  @override
  void initState() {
    super.initState();

    _loadPreferences();

    for (var i = 1; i <= 3; i++) {
      _players.add(TextEditingController(text: 'Player $i'));
    }
  }

  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _multiImposterMode = preferences.getBool('multi_imposter_mode') ?? false;
      _impostersKnowEachOther =
          preferences.getBool('imposters_know_each_other') ?? false;
      _newWordEveryRound =
          preferences.getBool('new_word_every_round') ?? false;
      _isPreferenceLoaded = true;

      if (!_multiImposterMode) {
        _imposterCount = 1;
      }
    });
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
    final names = _players.map((player) => player.text.trim()).toList();

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

    if (!WordBank.hasWordsFor(_difficulty)) {
      _showMessage('No such words exist. Please change difficulty.');
      return;
    }

    final imposterCount = _multiImposterMode ? _imposterCount : 1;

    if (imposterCount < 1 || imposterCount >= names.length) {
      _showMessage('Invalid imposter count.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameSessionScreen(
          players: List<String>.unmodifiable(names),
          imposterCount: imposterCount,
          impostersKnowEachOther: _impostersKnowEachOther,
          newWordEveryRound: _multiImposterMode && _newWordEveryRound,
          difficulty: _difficulty,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Player Setup')),
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
                                  decoration: const InputDecoration(
                                    hintText: 'Player name',
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove player',
                                onPressed:
                                    _players.length > 3 &&
                                        index == _players.length - 1
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
                    'DIFFICULTY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.secondary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose the word difficulty for this game.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: DropdownButtonFormField<WordDifficulty>(
                        initialValue: _difficulty,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: WordDifficulty.easy,
                            child: Text('Kunal Edition'),
                          ),
                          DropdownMenuItem(
                            value: WordDifficulty.medium,
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: WordDifficulty.hard,
                            child: Text('Hard'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _difficulty = value);
                          }
                        },
                      ),
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
                            onPressed:
                                _multiImposterMode &&
                                    _imposterCount < _players.length - 1
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
                    _multiImposterMode
                        ? 'At least one player must remain a normal player.'
                        : 'Multi-imposter mode is off. One imposter will be selected.',
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
                  onPressed: _isPreferenceLoaded ? _continue : null,
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
