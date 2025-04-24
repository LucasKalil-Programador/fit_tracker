import 'package:fittrackr/entities/exercise_plan.dart';
import 'package:flutter/material.dart';

class ExercisePlanState extends ChangeNotifier {
  final List<ExercisePlan> _planList = [];
  String? _activated;
  
  List<ExercisePlan> get planList => List.unmodifiable(_planList);

  String? get activated => _activated;
  set pausedTime(String? value) {
    final index = _planList.indexWhere((e) => e.id == value);
    if(index != -1) {
      _activated = value;
      notifyListeners();
    }
  }

  ExercisePlan? getActivated() {
    final index = _planList.indexWhere((e) => e.id == _activated);
    if(index != -1) {
      return _planList[index];
    }
    return null;
  }

  void addExercise(ExercisePlan exercise) {
    _planList.add(exercise);
    _planList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void updateExercise(ExercisePlan oldExercise, ExercisePlan exercise) {
    final index = _planList.indexWhere((e) => e.id == oldExercise.id);
    if (index != -1) {
      _planList[index] = exercise;
      _planList.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    }
  }

  void removeExercise(ExercisePlan exercise) {
    _planList.remove(exercise);
    notifyListeners();
  }

  void clearExercises() {
    _planList.clear();
    notifyListeners();
  }
}