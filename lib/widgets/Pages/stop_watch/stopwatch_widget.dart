import 'package:fittrackr/Controllers/stopwatch/stopwatch_controller.dart';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  final StopWatch stopWatchController;

  const StopwatchWidget({super.key, required this.stopWatchController});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget>  with SingleTickerProviderStateMixin {
  final ValueNotifier<Duration> elapsedDuration = ValueNotifier(Duration());
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(
            () => elapsedDuration.value = widget.stopWatchController.elapsed(),
          )
          ..repeat();
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
      builder: (_, value, _) => Center(child: _TimeText(elapsed: value)),
    );
  }
}

class _TimeText extends StatelessWidget {
  final Duration elapsed;

  const _TimeText({
    required this.elapsed, 
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        formatDuration(elapsed),
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
