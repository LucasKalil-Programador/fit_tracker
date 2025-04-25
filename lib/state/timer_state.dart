import 'package:fittrackr/database/db.dart';
import 'package:flutter/material.dart';

import '../entities/timer.dart';

class TimerState extends ChangeNotifier {
  DateTime? _pausedTime;
  DateTime? _startTime;
  bool _paused = true;

  DateTime? get pausedTime => _pausedTime;
  set pausedTime(DateTime? value) {
    _pausedTime = value;
    notifyListeners();
  }

  DateTime? get startTime => _startTime;
  set startTime(DateTime? value) {
    _startTime = value;
    notifyListeners();
  }

  bool get paused => _paused;
  set paused(bool value) {
    _paused = value;
    notifyListeners();
  }

  Future<bool> loadFromDatabase() async {
    Timer? loadedTimer = await DatabaseHelper().selectOne(1);
    if (loadedTimer != null) {
      this.startTime = loadedTimer.startTime;
      this.pausedTime = loadedTimer.pausedTime;
      this.paused = loadedTimer.paused;
      return true;
    } else {
      int result = await DatabaseHelper().insertTimer(
        Timer(
          id: 1,
          startTime: this.startTime,
          pausedTime: this.pausedTime,
          paused: this.paused,
        ),
      );
      return result > 0;
    }
  }

  Future<bool> saveToDatabase() async {
    Timer timer = Timer(
      id: 1,
      startTime: this.startTime,
      pausedTime: this.pausedTime,
      paused: this.paused,
    );
    int result = await DatabaseHelper().updateTimer(timer);
    return result > 0;
  }
}