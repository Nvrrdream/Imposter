
import 'package:flutter/services.dart';

class AndroidInstallerService {
  static const MethodChannel _channel = MethodChannel(
    'imposter/update_installer',
  );

  Future<bool> canInstallPackages() async {
    return await _channel.invokeMethod<bool>(
          'canInstallPackages',
        ) ??
        false;
  }

  Future<void> openInstallSettings() async {
    await _channel.invokeMethod<bool>('openInstallSettings');
  }

  Future<void> installApk(String path) async {
    await _channel.invokeMethod<bool>(
      'installApk',
      {'path': path},
    );
  }
}
