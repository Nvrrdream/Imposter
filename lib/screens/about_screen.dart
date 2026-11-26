import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<PackageInfo> _packageInfo;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 28),
          Icon(
            Icons.groups_rounded,
            size: 64,
            color: colors.primary,
          ),
          const SizedBox(height: 20),
          Text(
            'IMPOSTER',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'A social word game of secrets, suspicion and deception.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 36),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT THE GAME',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Everyone gets a secret word. One or more players are imposters and must figure out the word without being caught.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'APP INFORMATION',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Version'),
                      FutureBuilder<PackageInfo>(
                        future: _packageInfo,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data?.version ?? 'Loading...',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform'),
                      Text('Android'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Made for friends, played together.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
