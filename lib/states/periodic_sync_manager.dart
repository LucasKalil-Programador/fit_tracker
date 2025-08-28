import 'dart:async';

class PeriodicSyncManager {
  Timer? _periodicTimer;
  final void Function() _onSync;

  PeriodicSyncManager(this._onSync);

  void start(Duration interval) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (_) => _onSync());
  }

  void stop() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  bool get isRunning => _periodicTimer != null;
}
