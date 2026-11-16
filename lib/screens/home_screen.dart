
import 'package:material_ui/material_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenSettings,
    required this.onOpenAbout,
    required this.onPlay,
    super.key,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenAbout;
  final VoidCallback onPlay;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _hotspot({
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10090B),
      body: SizedBox.expand(
        child: FittedBox(
  fit: BoxFit.contain,
  child: SizedBox(
    width: 800,
    height: 1872,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/imposter_title_screen.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
  left: 75,
  top: 1325,
  width: 650,
  height: 205,
  child: _hotspot(
    tooltip: 'Play',
    onPressed: onPlay,
  ),
),
Positioned(
  left: 70,
  top: 1565,
  width: 150,
  height: 145,
  child: _hotspot(
    tooltip: 'Stats',
    onPressed: () => _showComingSoon(context, 'Stats'),
  ),
),
Positioned(
  left: 325,
  top: 1565,
  width: 150,
  height: 145,
  child: _hotspot(
    tooltip: 'About',
    onPressed: onOpenAbout,
  ),
),
Positioned(
  left: 580,
  top: 1565,
  width: 150,
  height: 145,
  child: _hotspot(
    tooltip: 'Settings',
    onPressed: onOpenSettings,
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
