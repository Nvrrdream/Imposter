import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/about_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString('app_theme');

    if (!mounted) return;

    setState(() {
      _themeMode = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_theme', mode == ThemeMode.light ? 'light' : 'dark');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imposter',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          return HomeScreen(
            onOpenSettings: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    themeMode: _themeMode,
                    onThemeChanged: _changeTheme,
                  ),
                ),
              );
            },
            onOpenAbout: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}