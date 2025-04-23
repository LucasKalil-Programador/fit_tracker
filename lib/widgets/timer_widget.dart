import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerStateState();
}

class _TimerStateState extends State<TimerWidget> {
  Timer? _timer;

  DateTime? pausedTime;
  DateTime? startTime;

  bool paused = true;
  String formatedElapsed = "00:00:00.000";
  

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final milliseconds = threeDigits(d.inMilliseconds.remainder(1000));

    return "$hours:$minutes:$seconds.$milliseconds";
  }

  void start() {
    paused = false;
    _timer?.cancel();

    if(pausedTime == null || startTime == null) {
      startTime = DateTime.now();
    } else {
      Duration elapsed = DateTime.now().difference(pausedTime!);
      startTime = startTime?.add(elapsed);
      pausedTime = null;
    }

    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      setState(() {
        if (startTime != null) {
          Duration elapsed = DateTime.now().difference(startTime!);
          formatedElapsed = formatDuration(elapsed);
        }
      });
    });
  }

  void pause() {
    paused = true;
    _timer?.cancel();
    pausedTime = DateTime.now();
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      paused = true;
      pausedTime = null;
      startTime = null;
      formatedElapsed = "00:00:00.000";
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
        Center(child: Text(formatedElapsed, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),)),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: reset,
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                      if(paused) {
                        start();
                      } else {
                        pause();
                      }
                  },
                  child: Icon(paused? Icons.play_arrow: Icons.pause),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}