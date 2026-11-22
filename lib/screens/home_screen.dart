
import 'package:material_ui/material_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenSettings,
    required this.onOpenAbout,
    required this.onPlay,
    this.onOpenHowToPlay,
    super.key,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenAbout;
  final VoidCallback onPlay;
  final VoidCallback? onOpenHowToPlay;

  static const Color _burgundy = Color(0xFF800020);
  static const Color _text = Color(0xFFFFF1E8);

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
      backgroundColor: const Color(0xFF10090B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/imposter_home_bg.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color(0x26000000),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                return Stack(
                  children: [
                    Positioned(
                      top: height * 0.040,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            'IMPOSTER',
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.w700,
                              fontSize: (width * 0.14).clamp(42.0, 56.0),
                              height: 0.95,
                              letterSpacing: 2.5,
                              color: _text,
                              shadows: [
                                Shadow(
                                  color: _burgundy.withValues(alpha: 0.45),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'TRUST NO ONE',
                            style: const TextStyle(
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              letterSpacing: 4,
                              color: Color(0xFFD51F32),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: width * 0.13,
                      right: width * 0.13,
                      bottom: height * 0.19,
                      height: 76,
                      child: _PlayButton(
                        onPressed: onPlay,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HexNavButton(
                            icon: Icons.auto_stories_rounded,
                            label: 'HOW TO PLAY',
                            onPressed: onOpenHowToPlay ??
                                () => _showComingSoon(context, 'How to Play'),
                          ),
                          _HexNavButton(
                            icon: Icons.info_rounded,
                            label: 'ABOUT',
                            onPressed: onOpenAbout,
                          ),
                          _HexNavButton(
                            icon: Icons.settings_suggest_rounded,
                            label: 'SETTINGS',
                            onPressed: onOpenSettings,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: _AngularButtonPainter(),
        child: Center(
          child: Text(
            'PLAY',
            style: const TextStyle(
              fontFamily: 'RubikGemstones',
              fontSize: 27,
              color: Color(0xFFFFF1E8),
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _HexNavButton extends StatelessWidget {
  const _HexNavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  static const Color _iconColor = Color(0xFFF1ECE8);
  static const Color _labelColor = Color(0xFFD6C2B0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Tooltip(
            message: label,
            child: GestureDetector(
              onTap: onPressed,
              child: CustomPaint(
                size: const Size(62, 62),
                painter: _HexagonPainter(),
                child: SizedBox(
                  width: 62,
                  height: 62,
                  child: Icon(
                    icon,
                    size: 29,
                    color: _iconColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.8,
              color: _labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AngularButtonPainter extends CustomPainter {
  Path _createButtonPath(Rect rect) {
    final cutX = rect.width * 0.05;
    final cutY = rect.height * 0.20;

    return Path()
      ..moveTo(rect.left + cutX, rect.top)
      ..lineTo(rect.right - cutX, rect.top)
      ..lineTo(rect.right, rect.top + cutY)
      ..lineTo(rect.right, rect.bottom - cutY)
      ..lineTo(rect.right - cutX, rect.bottom)
      ..lineTo(rect.left + cutX, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cutY)
      ..lineTo(rect.left, rect.top + cutY)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final outerPath = _createButtonPath(bounds);

    canvas.drawShadow(
      outerPath,
      const Color(0xDD000000),
      7,
      false,
    );

    final fill = Paint()
      ..color = const Color(0xFF241116)
      ..style = PaintingStyle.fill;

    canvas.drawPath(outerPath, fill);

    final outerBorder = Paint()
      ..color = const Color(0xFFD51F32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(outerPath, outerBorder);

    final innerBounds = bounds.deflate(4);
    final innerPath = _createButtonPath(innerBounds);

    final innerBorder = Paint()
      ..color = const Color(0x99800020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(innerPath, innerBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.25, 2)
      ..lineTo(size.width * 0.75, 2)
      ..lineTo(size.width - 2, size.height * 0.25)
      ..lineTo(size.width - 2, size.height * 0.75)
      ..lineTo(size.width * 0.75, size.height - 2)
      ..lineTo(size.width * 0.25, size.height - 2)
      ..lineTo(2, size.height * 0.75)
      ..lineTo(2, size.height * 0.25)
      ..close();

    canvas.drawShadow(
      path,
      const Color(0xCC000000),
      5,
      false,
    );

    final fill = Paint()
      ..color = const Color(0xFF17151B)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fill);

    final border = Paint()
      ..color = const Color(0xFF800020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7;

    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
