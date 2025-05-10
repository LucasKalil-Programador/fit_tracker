import 'package:synchronized/synchronized.dart';
import 'dart:async';

class DebounceRunner {
  Duration delay;
  Future<void> Function() callback;

  Timer? _debouncer;
  final _lock = Lock();

  DebounceRunner({required this.delay, required this.callback});

  void runAfter() {
    _debouncer?.cancel();
    _debouncer = Timer(delay, run);
  }

  Future<void> run([bool debug = false]) async {
    late DateTime start;
    await _lock.synchronized(() async {
      if(debug) start = DateTime.now();
      
      await callback();

      if(debug) {
        final elapsed = DateTime.now().difference(start);
        print("Save took: $elapsed");
      }
    });
  }
}