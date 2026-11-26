
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/about_screen.dart';
import 'screens/home_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/player_setup_screen.dart';
import 'screens/settings_screen.dart';
import 'services/android_installer_service.dart';
import 'services/update_coordinator.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final UpdateCoordinator _updateCoordinator = UpdateCoordinator();
  final AndroidInstallerService _installer = AndroidInstallerService();

  late final _AppRouteObserver _routeObserver =
      _AppRouteObserver(_maybePromptForUpdate);

  ThemeMode _themeMode = ThemeMode.dark;
  bool _isUpdateDialogShowing = false;
  bool _waitingForInstallPermission = false;
  String? _pendingInstallPath;
  String? _promptedReleaseTag;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateCoordinator.addListener(_onUpdateChanged);
    _loadTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCoordinator.checkForUpdate();
    });
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
    await preferences.setString(
      'app_theme',
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  void _onUpdateChanged() {
    _maybePromptForUpdate();
  }

  Future<void> _maybePromptForUpdate() async {
    final release = _updateCoordinator.release;

    if (!mounted ||
        !_routeObserver.isHomeVisible ||
        !_updateCoordinator.isReady ||
        release == null ||
        _isUpdateDialogShowing ||
        _promptedReleaseTag == release.tagName) {
      return;
    }

    final context = _navigatorKey.currentContext;
    if (context == null) return;

    _promptedReleaseTag = release.tagName;
    _isUpdateDialogShowing = true;

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Update available: ${release.version}'),
            content: SingleChildScrollView(
              child: Text(
                release.notes.trim().isEmpty
                    ? 'A newer version of Imposter has been downloaded and verified.'
                    : release.notes,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _installUpdate();
                },
                child: const Text('Install'),
              ),
            ],
          );
        },
      );
    } finally {
      _isUpdateDialogShowing = false;
    }
  }

  Future<void> _installUpdate() async {
    final path = _updateCoordinator.apkPath;
    if (path == null) return;

    try {
      final allowed = await _installer.canInstallPackages();

      if (!allowed) {
        _pendingInstallPath = path;
        _waitingForInstallPermission = true;
        await _installer.openInstallSettings();
        return;
      }

      await _installer.installApk(path);
    } on PlatformException catch (exception) {
      _waitingForInstallPermission = false;
      _pendingInstallPath = null;
      _showMessage(exception.message ?? 'Unable to open the installer.');
    } catch (exception) {
      _waitingForInstallPermission = false;
      _pendingInstallPath = null;
      _showMessage('Installation error: $exception');
    }
  }

  Future<void> _resumePendingInstallation() async {
    if (!_waitingForInstallPermission || _pendingInstallPath == null) {
      return;
    }

    try {
      final allowed = await _installer.canInstallPackages();

      if (!mounted) return;

      if (allowed) {
        final path = _pendingInstallPath!;
        _waitingForInstallPermission = false;
        _pendingInstallPath = null;
        await _installer.installApk(path);
      } else {
        _waitingForInstallPermission = false;
        _pendingInstallPath = null;
        _showMessage(
          'Installation permission was not enabled. You can try again from Settings.',
        );
      }
    } catch (exception) {
      _waitingForInstallPermission = false;
      _pendingInstallPath = null;
      _showMessage('Unable to check installation permission: $exception');
    }
  }

  void _showMessage(String message) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumePendingInstallation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _updateCoordinator.removeListener(_onUpdateChanged);
    _updateCoordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: _messengerKey,
      navigatorObservers: [_routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Imposter',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          return HomeScreen(
            onPlay: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/game'),
                  builder: (_) => const PlayerSetupScreen(),
                ),
              );
            },
            onOpenSettings: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/settings'),
                  builder: (_) => SettingsScreen(
                    themeMode: _themeMode,
                    onThemeChanged: _changeTheme,
                    updateCoordinator: _updateCoordinator,
                    onInstallUpdate: _installUpdate,
                  ),
                ),
              );
            },
            onOpenAbout: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/about'),
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
            onOpenHowToPlay: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/how-to-play'),
                  builder: (_) => const HowToPlayScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AppRouteObserver extends NavigatorObserver {
  _AppRouteObserver(this.onHomeVisible);

  final VoidCallback onHomeVisible;
  final List<Route<dynamic>> _routes = [];

  bool get isHomeVisible =>
      _routes.isNotEmpty && _routes.last.settings.name == '/';

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isHomeVisible) onHomeVisible();
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _routes.add(route);
    _notify();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);
    _notify();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
