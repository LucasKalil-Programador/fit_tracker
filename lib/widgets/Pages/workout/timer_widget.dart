import 'dart:async';

import 'package:flutter/material.dart';

class TimerData {
  final bool paused;
  final DateTime? startTime;
  final DateTime? pausedTime;

  const TimerData({this.pausedTime, this.startTime, this.paused = true});
}

class TimerWidget extends StatefulWidget {
  final int updateDelayMs;
  final TimerData? timerData;
  final void Function(TimerData)? onTimerChanged;

  const TimerWidget({super.key, this.timerData, this.onTimerChanged, this.updateDelayMs = 25});

  @override
  State<TimerWidget> createState() => _TimerStateState();
}

class _TimerStateState extends State<TimerWidget> {
  Timer? _timer;

  final String placeholderElapsed = "00:00:00.00";
  String formatedElapsed = "00:00:00.00";

  bool paused = true;
  DateTime? startTime;
  DateTime? pausedTime;

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if(widget.timerData != null) {
      final timerData = widget.timerData!;
      paused = timerData.paused;
      startTime = timerData.startTime;
      pausedTime = timerData.pausedTime;
    }

    if(!paused) {
      _startUpdater();
    } else {
      setState(() {
        if (startTime != null && pausedTime != null) {
          Duration elapsed = pausedTime!.difference(startTime!);
          formatedElapsed = _formatDuration(elapsed);
        }
      });
    }
  }

  Widget playPauseButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shadowColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
      ),
      onPressed: () => (paused ? _start : _pause)(),
      child: Icon(paused ? Icons.play_arrow : Icons.pause, size: 30),
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
      onPressed: _reset,
      child: const Icon(Icons.refresh, size: 30),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final milliseconds = twoDigits(d.inMilliseconds.remainder(1000) ~/ 10);

    return "$hours:$minutes:$seconds.$milliseconds";
  }

  void _notifyChange() {
    if(widget.onTimerChanged != null) {
      widget.onTimerChanged!(TimerData(pausedTime: pausedTime, startTime: startTime, paused: paused));
    }
  }

  void _pause() {
    _timer?.cancel();
    paused = true;
    pausedTime = DateTime.now();

    if (startTime != null) {
      Duration elapsed = pausedTime!.difference(startTime!);
      formatedElapsed = _formatDuration(elapsed);
    }
    _notifyChange();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      paused = true;
      pausedTime = null;
      startTime = null;
      formatedElapsed = placeholderElapsed;
    });
    _notifyChange();
  }

  void _start() {
    paused = false;
    _timer?.cancel();

    if(pausedTime == null || startTime == null) {
      startTime = DateTime.now();
    } else {
      Duration elapsed = DateTime.now().difference(pausedTime!);
      startTime = startTime?.add(elapsed);
      pausedTime = null;
    }

    _startUpdater();
    _notifyChange();
  }

  void _startUpdater() {
    _timer = Timer.periodic(Duration(milliseconds: widget.updateDelayMs), (timer) {
      setState(() {
        if (startTime != null) {
          Duration elapsed = DateTime.now().difference(startTime!);
          formatedElapsed = _formatDuration(elapsed);
        }
      });
    });
  }
}
