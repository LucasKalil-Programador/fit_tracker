import 'package:flutter/material.dart';

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
}