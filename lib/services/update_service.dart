
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppRelease {
  const AppRelease({
    required this.version,
    required this.buildNumber,
    required this.tagName,
    required this.name,
    required this.notes,
    required this.downloadUrl,
    required this.sha256,
    required this.size,
  });

  final String version;
  final int buildNumber;
  final String tagName;
  final String name;
  final String notes;
  final String downloadUrl;
  final String sha256;
  final int size;
}

class UpdateService {
  UpdateService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _releaseUrl =
      'https://api.github.com/repos/Nvrrdream/Imposter/releases/latest';

  static const _apkName = 'app-release.apk';

  void dispose() {
    _client.close();
  }

  Future<AppRelease?> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final response = await _client
        .get(
          Uri.parse(_releaseUrl),
          headers: {
            'Accept': 'application/vnd.github+json',
            'User-Agent': 'Imposter-Android-Updater',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw HttpException(
        'GitHub returned HTTP ${response.statusCode}.',
      );
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid release response.');
    }

    if (data['draft'] == true || data['prerelease'] == true) {
      return null;
    }

    final tagName = data['tag_name'] as String?;
    if (tagName == null) {
      throw const FormatException('Release tag is missing.');
    }

    final match = RegExp(
      r'^v?(\d+)\.(\d+)\.(\d+)\+(\d+)$',
    ).firstMatch(tagName);

    if (match == null) {
      return null;
    }

    final latestVersion = [
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    ];

    final latestBuild = int.parse(match.group(4)!);

    final currentVersion = packageInfo.version
        .split('.')
        .map(int.parse)
        .toList();

    final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

    if (!_isNewer(
      latestVersion,
      latestBuild,
      currentVersion,
      currentBuild,
    )) {
      return null;
    }

    final assets = data['assets'];

    if (assets is! List) {
      throw const FormatException('Release assets are missing.');
    }

    final asset = assets.cast<Map<String, dynamic>>().where(
      (item) => item['name'] == _apkName,
    ).firstOrNull;

    if (asset == null) {
      throw const FormatException('Release APK is missing.');
    }

    final downloadUrl = asset['browser_download_url'] as String?;
    final digest = asset['digest'] as String?;
    final size = asset['size'] as int?;

    if (downloadUrl == null ||
        Uri.tryParse(downloadUrl)?.host != 'github.com') {
      throw const FormatException('Invalid APK download URL.');
    }

    final digestMatch = digest == null
        ? null
        : RegExp(r'^sha256:([a-fA-F0-9]{64})$').firstMatch(digest);

    if (digestMatch == null) {
      throw const FormatException('Release SHA-256 digest is missing or invalid.');
    }

    if (size == null || size <= 0) {
      throw const FormatException('Invalid APK size.');
    }

    return AppRelease(
      version: '${latestVersion[0]}.${latestVersion[1]}.${latestVersion[2]}',
      buildNumber: latestBuild,
      tagName: tagName,
      name: data['name'] as String? ?? tagName,
      notes: data['body'] as String? ?? '',
      downloadUrl: downloadUrl,
      sha256: digestMatch.group(1)!.toLowerCase(),
      size: size,
    );
  }

  bool _isNewer(
    List<int> latestVersion,
    int latestBuild,
    List<int> currentVersion,
    int currentBuild,
  ) {
    for (var i = 0; i < 3; i++) {
      if (latestVersion[i] != currentVersion[i]) {
        return latestVersion[i] > currentVersion[i];
      }
    }

    return latestBuild > currentBuild;
  }

  Future<String> downloadUpdate(
    AppRelease release, {
    void Function(int received, int total)? onProgress,
  }) async {
    final directory = await getApplicationSupportDirectory();

    final file = File(
      '${directory.path}/imposter-${release.version}-${release.buildNumber}.apk',
    );

    if (await file.exists()) {
      final existingHash = await sha256.bind(file.openRead()).first;

      if (existingHash.toString() == release.sha256) {
        return file.path;
      }

      await file.delete();
    }

    final response = await _client
        .send(http.Request('GET', Uri.parse(release.downloadUrl)))
        .timeout(const Duration(minutes: 5));

    if (response.statusCode != 200) {
      throw HttpException(
        'APK download failed: HTTP ${response.statusCode}.',
      );
    }

    final sink = file.openWrite();
    var received = 0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, release.size);
      }

      await sink.flush();
    } catch (_) {
      await sink.close();

      if (await file.exists()) {
        await file.delete();
      }

      rethrow;
    }

    await sink.close();

    if (received != release.size) {
      await file.delete();
      throw const FormatException('Downloaded APK size does not match.');
    }

    final downloadedHash = await sha256.bind(file.openRead()).first;

    if (downloadedHash.toString() != release.sha256) {
      await file.delete();
      throw const FormatException('APK checksum verification failed.');
    }

    return file.path;
  }
}
