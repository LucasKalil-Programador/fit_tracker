import 'dart:async';
import 'package:fittrackr/state/timer_state.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final TimerState timerState;

  const TimerWidget({super.key, required this.timerState});

  @override
  State<TimerWidget> createState() => _TimerStateState();
}

class _TimerStateState extends State<TimerWidget> {
  Timer? _timer;

  final String placeholderElapsed = "00:00:00.00";
  String formatedElapsed = "00:00:00.00";

  @override
  void initState() {
    super.initState();

    if(!widget.timerState.paused) {
      _startUpdater();
    } else {
      setState(() {
        if (widget.timerState.startTime != null && widget.timerState.pausedTime != null) {
          Duration elapsed = widget.timerState.pausedTime!.difference(widget.timerState.startTime!);
          formatedElapsed = formatDuration(elapsed);
        }
      });
    }
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final milliseconds = twoDigits(d.inMilliseconds.remainder(1000) ~/ 10);

    return "$hours:$minutes:$seconds.$milliseconds";
  }

  void start() {
    widget.timerState.paused = false;
    _timer?.cancel();

    if(widget.timerState.pausedTime == null || widget.timerState.startTime == null) {
      widget.timerState.startTime = DateTime.now();
    } else {
      Duration elapsed = DateTime.now().difference(widget.timerState.pausedTime!);
      widget.timerState.startTime = widget.timerState.startTime?.add(elapsed);
      widget.timerState.pausedTime = null;
    }

    _startUpdater();
  }

  void _startUpdater() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (widget.timerState.startTime != null) {
          Duration elapsed = DateTime.now().difference(widget.timerState.startTime!);
          formatedElapsed = formatDuration(elapsed);
        }
      });
    });
  }

  void pause() {
    _timer?.cancel();
    widget.timerState.paused = true;
    widget.timerState.pausedTime = DateTime.now();

    if (widget.timerState.startTime != null) {
      Duration elapsed = widget.timerState.pausedTime!.difference(widget.timerState.startTime!);
      formatedElapsed = formatDuration(elapsed);
    }
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      widget.timerState.paused = true;
      widget.timerState.pausedTime = null;
      widget.timerState.startTime = null;
      formatedElapsed = placeholderElapsed;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(formatedElapsed, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: resetButton(context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: playPauseButton(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget playPauseButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shadowColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
      ),
      onPressed: () {
        if (widget.timerState.paused) {
          start();
        } else {
          pause();
        }
      },
      child: Icon(widget.timerState.paused ? Icons.play_arrow : Icons.pause, size: 30),
    );
  }

  Widget resetButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shadowColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
      ),
      onPressed: reset,
      child: const Icon(Icons.refresh, size: 30),
    );
  }
}
