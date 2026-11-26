import 'package:material_ui/material_ui.dart';

class RoundBackScope extends StatefulWidget {
  const RoundBackScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static void exitToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  State<RoundBackScope> createState() => _RoundBackScopeState();
}

class _RoundBackScopeState extends State<RoundBackScope> {
  DateTime? _lastBackPress;

  void _handleBack() {
    final now = DateTime.now();

    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) <= const Duration(seconds: 2)) {
      _lastBackPress = null;
      RoundBackScope.exitToHome(context);
      return;
    }

    _lastBackPress = now;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Press again to exit round'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: widget.child,
    );
  }
}