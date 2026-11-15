import 'package:material_ui/material_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.themeMode,
    required this.onThemeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

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
                  const Text('App theme', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Choose how the app looks.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selection) => onThemeChanged(selection.first),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
