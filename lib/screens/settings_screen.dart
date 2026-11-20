import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/word_entry.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.themeMode,
    required this.onThemeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _multiImposterMode = false;
  bool _impostersKnowEachOther = false;
  bool _newWordEveryRound = false;
  WordDifficulty _difficulty = WordDifficulty.medium;
  bool _isPreferenceLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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
      _difficulty = WordDifficulty.values.firstWhere(
        (difficulty) => difficulty.name == preferences.getString('word_difficulty'),
        orElse: () => WordDifficulty.medium,
      );      _isPreferenceLoaded = true;
    });
  }

  Future<void> _setMultiImposterMode(bool value) async {
    setState(() {
      _multiImposterMode = value;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('multi_imposter_mode', value);
  }

  Future<void> _setImposterPreference(bool value) async {
    setState(() {
      _impostersKnowEachOther = value;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('imposters_know_each_other', value);
  }

  Future<void> _setNewWordEveryRound(bool value) async {
    setState(() {
      _newWordEveryRound = value;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('new_word_every_round', value);
  }

  Future<void> _setDifficulty(WordDifficulty value) async {
    setState(() {
      _difficulty = value;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('word_difficulty', value.name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('APPEARANCE', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App theme',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose how the app looks.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                    selected: {widget.themeMode},
                    onSelectionChanged: (selection) =>
                        widget.onThemeChanged(selection.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('GAME', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Word difficulty',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose the word difficulty for new games.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<WordDifficulty>(
                    initialValue: _difficulty,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: WordDifficulty.easy,
                        child: Text('Kunal Edition'),
                      ),
                      DropdownMenuItem(
                        value: WordDifficulty.medium,
                        child: Text('Niche'),
                      ),
                      DropdownMenuItem(
                        value: WordDifficulty.hard,
                        child: Text('EliteBall'),
                      ),
                    ],
                    onChanged: _isPreferenceLoaded
                        ? (value) {
                            if (value != null) _setDifficulty(value);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Multi-imposter mode'),
                  subtitle: const Text('Allow more than one imposter in a game.'),
                  value: _multiImposterMode,
                  onChanged: _isPreferenceLoaded ? _setMultiImposterMode : null,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Card(
                    child: SwitchListTile(
                      title: const Text('New Word Every Round'),
                      subtitle: const Text(
                        'Give surviving players a new word after each vote.',
                      ),
                      value: _newWordEveryRound,
                      onChanged: _isPreferenceLoaded && _multiImposterMode
                          ? _setNewWordEveryRound
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: SwitchListTile(
              title: const Text('Imposters know each other'),
              subtitle: const Text(
                'Show each imposter the names of the others.',
              ),
              value: _impostersKnowEachOther,
              onChanged: _isPreferenceLoaded ? _setImposterPreference : null,
            ),
          ),
        ],
      ),
    );
  }
}
