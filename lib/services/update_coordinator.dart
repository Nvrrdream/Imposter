
import 'package:flutter/foundation.dart';

import 'update_service.dart';

enum UpdateStatus {
  idle,
  checking,
  downloading,
  ready,
  upToDate,
  failed,
}

class UpdateCoordinator extends ChangeNotifier {
  UpdateCoordinator({UpdateService? updateService})
      : _updateService = updateService ?? UpdateService();

  final UpdateService _updateService;

  UpdateStatus _status = UpdateStatus.idle;
  AppRelease? _release;
  String? _apkPath;
  String? _error;
  double _downloadProgress = 0;
  bool _isBusy = false;
  bool _hasChecked = false;

  UpdateStatus get status => _status;
  AppRelease? get release => _release;
  String? get apkPath => _apkPath;
  String? get error => _error;
  double get downloadProgress => _downloadProgress;
  bool get isBusy => _isBusy;
  bool get isReady => _status == UpdateStatus.ready;

  Future<void> checkForUpdate({bool force = false}) async {
    if (_isBusy || (_hasChecked && !force)) return;

    _isBusy = true;
    _hasChecked = true;
    _status = UpdateStatus.checking;
    _error = null;
    notifyListeners();

    try {
      final release = await _updateService.checkForUpdate();

      if (release == null) {
        _release = null;
        _apkPath = null;
        _status = UpdateStatus.upToDate;
        return;
      }

      _release = release;
      _downloadProgress = 0;
      _status = UpdateStatus.downloading;
      notifyListeners();

      _apkPath = await _updateService.downloadUpdate(
        release,
        onProgress: (received, total) {
          if (total > 0) {
            _downloadProgress = (received / total).clamp(0.0, 1.0);
            notifyListeners();
          }
        },
      );

      _downloadProgress = 1;
      _status = UpdateStatus.ready;
    } catch (exception) {
      _error = exception.toString();
      _status = UpdateStatus.failed;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _updateService.dispose();
    super.dispose();
  }
}
