import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:async';

class DebounceRunner<T> {
  final Duration delay;
  Future Function(T) callback;

  Timer? _debouncer;
  final _lock = Lock();

  DebounceRunner({required this.delay, required this.callback});

  void runAfter(T element, [bool useCompute = false]) {
    _debouncer?.cancel();
    _debouncer = Timer(delay, () => run(element, useCompute));
  }

  Future<void> run(T element, [bool useCompute = false]) async {
    await _lock.synchronized(() async {
      final start = DateTime.now();

      if (useCompute) {
        await compute(callback, element);
      } else {
        await callback(element);
      }
      
      final elapsed = DateTime.now().difference(start);
      print("Save took: $elapsed");
    });
  }
}