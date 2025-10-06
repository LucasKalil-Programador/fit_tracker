
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stopwatch_controller.g.dart';


@Riverpod(keepAlive: true)
class StopwatchController extends _$StopwatchController {
  @override
  List<StopWatch> build() => const [StopWatch()];

  void add(StopWatch stopwatch) {
    state = List.unmodifiable([...state, stopwatch]);
  }

  void removeAt(int index) {
    if(state.length <= 1) {
      state = const [StopWatch()];
      return;
    }
    
    state = List.unmodifiable([
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ]);
  }

  void startAt(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].start() else state[i],
    ];
  }

  void pauseAt(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].pause() else state[i],
    ];
  }

  void resetAt(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].reset() else state[i],
    ];
  }

  void updateAt(int index, StopWatch newStopwatch) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) newStopwatch else state[i],
    ];
  }
}

@immutable
class StopWatch {
  final DateTime? startTime;
  final DateTime? pausedTime;

  DateTime get _now => DateTime.now().toUtc();

  bool get isZeroed => elapsed() == Duration();
  bool get isPaused => pausedTime != null || startTime == null;
  bool get isNotPaused => !isPaused;

  const StopWatch({
    this.startTime,
    this.pausedTime,
  });

  StopWatch start() {
    DateTime newStartTime = _now;
    if (pausedTime != null && startTime != null) {
      final pausedDuration = _now.difference(pausedTime!);
      newStartTime = startTime!.add(pausedDuration);
    }

    return StopWatch(startTime: newStartTime, pausedTime: null);
  }

  StopWatch pause() {
    if(isNotPaused) {
      return StopWatch(startTime: startTime, pausedTime: _now);
    } 
    return this;
  }

  StopWatch reset() => StopWatch(startTime: null, pausedTime: null);

  Duration elapsed() {
    if(startTime == null) {
      return Duration();
    }

    if(pausedTime != null) {
      return pausedTime!.difference(startTime!);
    }

    return _now.difference(startTime!);
  }

  @override
  bool operator ==(Object other) {
    return other is StopWatch &&
        other.startTime == startTime &&
        other.pausedTime == pausedTime;
  }

  @override
  int get hashCode => Object.hash(startTime, pausedTime);

  Map<String, String?> toJson() {
    return {
      "start_time": startTime?.toIso8601String(),
      "paused_time": pausedTime?.toIso8601String(),
    };
  }

  static StopWatch? fromJson(Map<String, Object?> e) {
    final startTime = e["start_time"];
    final pausedTime = e["paused_time"];
    if(startTime is String? && pausedTime is String?) {
      final controller = StopWatch(
        startTime: startTime != null ? DateTime.parse(startTime) : null,
        pausedTime: pausedTime != null ? DateTime.parse(pausedTime) : null,
      );
      return controller;
    }
    return null;
  }
}
