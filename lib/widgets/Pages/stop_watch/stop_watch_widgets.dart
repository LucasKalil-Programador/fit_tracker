import 'package:flutter/material.dart';

class StopWatchWidget extends StatefulWidget {
  final StopWatchController stopWatchController;

  const StopWatchWidget({super.key, required this.stopWatchController});

  @override
  State<StopWatchWidget> createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget>  with SingleTickerProviderStateMixin {
  final ValueNotifier<Duration> elapsedDuration = ValueNotifier(Duration());
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animationController.addListener(() {
      elapsedDuration.value = widget.stopWatchController.elapsed();
    });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: elapsedDuration,
      builder:
          (context, value, child) => Center(
            child: TimeText(elapsed: widget.stopWatchController.elapsed()),
          ),
    );
  }
}


class TimeText extends StatelessWidget {
  final String Function(Duration elapsed)? formatFunction;
  final Duration elapsed;

  const TimeText({
    super.key, required this.elapsed, this.formatFunction, 
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        (formatFunction ?? formatDuration)(elapsed),
        style: TextStyle(fontSize: 1000, fontWeight: FontWeight.bold),
      ),
    );
  }

  String formatDuration(Duration elapsed) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(elapsed.inHours);
    final minutes = twoDigits(elapsed.inMinutes.remainder(60));
    final seconds = twoDigits(elapsed.inSeconds.remainder(60));
    final milliseconds = twoDigits(elapsed.inMilliseconds.remainder(1000) ~/ 10);

    return "$hours:$minutes:$seconds.$milliseconds";
  }
}


class StopWatchController extends ChangeNotifier {
  DateTime? _startTime;
  DateTime? _pausedTime;

  DateTime get _now => DateTime.now().toUtc();

  bool get isZeroed => elapsed() == Duration();

  bool get isPaused => _pausedTime != null || _startTime == null;
  bool get isNotPaused => !isPaused;

  void start() {
    if(_pausedTime != null && _startTime != null) {
      final pausedDuration = _now.difference(_pausedTime!);
      _startTime = _startTime!.add(pausedDuration);
    } else {
      _startTime = _now;
    }  

    _pausedTime = null;
    notifyListeners();
  }

  void pause() {
    if(isNotPaused) {
      _pausedTime = _now;
    }
    notifyListeners();
  }

  void reset() {
    _startTime = null;
    _pausedTime = null;
    notifyListeners();
  }

  Duration elapsed() {
    if(_startTime == null) {
      return Duration();
    }

    if(_pausedTime != null) {
      return _pausedTime!.difference(_startTime!);
    }

    return _now.difference(_startTime!);
  }

  Map<String, String?> toJson() {
    return {
      "start_time": _startTime?.toIso8601String(),
      "paused_time": _pausedTime?.toIso8601String(),
    };
  }

  static StopWatchController? fromJson(Map<String, Object?> e) {
    final startTime = e["start_time"];
    final pausedTime = e["paused_time"];
    if(startTime is String? && pausedTime is String?) {
      final controller = StopWatchController();
      controller._startTime = startTime != null ? DateTime.parse(startTime) : null;
      controller._pausedTime = pausedTime != null ? DateTime.parse(pausedTime) : null;
      return controller;
    }
    return null;
  }
}
