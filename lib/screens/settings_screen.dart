import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _impostersKnowEachOther = false;
  bool _isPreferenceLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImposterPreference();
  }

  Future<void> _loadImposterPreference() async {
    final preferences = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _impostersKnowEachOther =
          preferences.getBool('imposters_know_each_other') ?? false;
      _isPreferenceLoaded = true;
    });
  }

  Future<void> _setImposterPreference(bool value) async {
    setState(() {
      _impostersKnowEachOther = value;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('imposters_know_each_other', value);
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
            child: SwitchListTile(
              title: const Text('Imposters know each other'),
              subtitle: const Text(
                'Show each imposter the names of the others.',
              ),
              value: _impostersKnowEachOther,
              onChanged:
                  _isPreferenceLoaded ? _setImposterPreference : null,
            ),
          ),
        ],
      ),
    );
  }
}
