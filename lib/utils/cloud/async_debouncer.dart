import 'dart:async';

class AsyncDebouncer {
  final Duration delay;
  Timer? _timer;
  Completer<void>? _running;
  bool _pending = false;

  AsyncDebouncer({required this.delay});

  Future<void> call(Future<void> Function() action) async {
    _timer?.cancel();
    _timer = Timer(delay, () async {
      if (_running != null) {
        _pending = true;
        return;
      }

      _running = Completer<void>();
      await action();
      _running!.complete();
      _running = null;

      if (_pending) {
        _pending = false;
        await call(action);
      }
    });
  }
}
