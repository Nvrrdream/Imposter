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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OctagonalIconButton(
                  icon: Icons.settings_rounded,
                  tooltip: 'Settings',
                  onPressed: onOpenSettings,
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: CustomPlayButton(
                    onPressed: () => _showComingSoon(context, 'New game'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: HomeAccentLine()),
                  const SizedBox(width: 14),
                  OctagonalIconButton(
                    icon: Icons.bar_chart_rounded,
                    tooltip: 'Stats',
                    onPressed: () => _showComingSoon(context, 'Stats'),
                  ),
                  const SizedBox(width: 18),
                  OctagonalIconButton(
                    icon: Icons.info_rounded,
                    tooltip: 'About',
                    onPressed: onOpenAbout,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(child: HomeAccentLine()),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class OctagonalIconButton extends StatelessWidget {
  const OctagonalIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onPrimary;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 48,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB51F42).withValues(alpha: 0.22),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipPath(
            clipper: OctagonalClipper(),
            child: CustomPaint(
              foregroundPainter: OctagonalBorderPainter(),
              child: Material(
                color: const Color(0xFF211619),
                child: InkWell(
                  onTap: onPressed,
                  splashColor: const Color(0x44D83B5D),
                  highlightColor: const Color(0x22D83B5D),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 22,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OctagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 11.0;

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

class OctagonalBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cut = 11.0;

    final path = Path()
      ..moveTo(cut, 0.8)
      ..lineTo(size.width - cut, 0.8)
      ..lineTo(size.width - 0.8, cut)
      ..lineTo(size.width - 0.8, size.height - cut)
      ..lineTo(size.width - cut, size.height - 0.8)
      ..lineTo(cut, size.height - 0.8)
      ..lineTo(0.8, size.height - cut)
      ..lineTo(0.8, cut)
      ..close();

    final glowPaint = Paint()
      ..color = const Color(0xFFCF294D).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final borderPaint = Paint()
      ..color = const Color(0xFFE34A68)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeAccentLine extends StatelessWidget {
  const HomeAccentLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x00C52B4D),
            Color(0xFFB72A49),
          ],
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
                    Color(0xFF9E2946),
                    Color(0xFF67182D),
                    Color(0xFF35101D),
                  ],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 34,
                    color: Color(0xFFFFE9DF),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'PLAY',
                    style: TextStyle(
                      color: Color(0xFFFFE9DF),
                      fontFamily: 'Rajdhani',
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
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
    return Path()
      ..moveTo(22, 0)
      ..lineTo(size.width - 9, 0)
      ..lineTo(size.width, 15)
      ..lineTo(size.width - 17, size.height)
      ..lineTo(8, size.height)
      ..lineTo(0, size.height - 13)
      ..lineTo(13, 18)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class PlayButtonBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(22, 1)
      ..lineTo(size.width - 9, 1)
      ..lineTo(size.width - 1, 15)
      ..lineTo(size.width - 18, size.height - 1)
      ..lineTo(8, size.height - 1)
      ..lineTo(1, size.height - 13)
      ..lineTo(13, 18)
      ..close();

    final glowPaint = Paint()
      ..color = const Color(0xFFD72D50).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final borderPaint = Paint()
      ..color = const Color(0xFFE3A0A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, borderPaint);

    final accentPaint = Paint()
      ..color = const Color(0xFFFFD3C9)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(
      const Offset(24, 4),
      const Offset(48, 4),
      accentPaint,
    );

    canvas.drawLine(
      Offset(size.width - 49, size.height - 4),
      Offset(size.width - 27, size.height - 4),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}