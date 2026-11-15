import 'package:material_ui/material_ui.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenSettings,
    required this.onOpenAbout,
    super.key,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenAbout;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: onOpenSettings,
                      icon: const Icon(Icons.settings_outlined),
                      iconSize: 26,
                      color: Theme.of(context).colorScheme.onSurface,
                      tooltip: 'Settings',
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 420,
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: CustomPlayButton(
                        onPressed: () => _showComingSoon(context, 'New game'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _showComingSoon(context, 'Stats'),
                        icon: const Icon(Icons.bar_chart_rounded),
                        color: Theme.of(context).colorScheme.onSurface,
                        tooltip: 'Stats',
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: onOpenAbout,
                        icon: const Icon(Icons.info_outline_rounded),
                        color: Theme.of(context).colorScheme.onSurface,
                        tooltip: 'About',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomPlayButton extends StatelessWidget {
  const CustomPlayButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PlayButtonClipper(),
      child: CustomPaint(
        foregroundPainter: PlayButtonBorderPainter(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            splashColor: const Color(0x55FFD9D0),
            highlightColor: const Color(0x22FFD9D0),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8F243D),
                    Color(0xFF641629),
                    Color(0xFF3A111D),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 30,
                    color: Color(0xFFFFE9DF),
                  ),
                  SizedBox(width: 9),
                  Text(
                    'PLAY',
                    style: TextStyle(
                      color: Color(0xFFFFE9DF),
                      fontFamily: 'Rajdhani',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 10.0;

    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width - cut, 0)
      ..lineTo(size.width, cut)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(cut, size.height)
      ..lineTo(0, size.height - cut)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class PlayButtonBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cut = 10.0;

    final borderPath = Path()
      ..moveTo(cut, 1)
      ..lineTo(size.width - cut, 1)
      ..lineTo(size.width - 1, cut)
      ..lineTo(size.width - 1, size.height - cut)
      ..lineTo(size.width - cut, size.height - 1)
      ..lineTo(cut, size.height - 1)
      ..lineTo(1, size.height - cut)
      ..lineTo(1, cut)
      ..close();

    final borderPaint = Paint()
      ..color = const Color(0xFFD99A9D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(borderPath, borderPaint);

    final accentPaint = Paint()
      ..color = const Color(0xFFFFD3C9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(
      const Offset(13, 4),
      const Offset(29, 4),
      accentPaint,
    );

    canvas.drawLine(
      Offset(size.width - 29, size.height - 4),
      Offset(size.width - 13, size.height - 4),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
