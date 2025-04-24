import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListState extends ChangeNotifier {
  final List<Exercise> _exercisesList = [];
  
  List<Exercise> get exercisesList => List.unmodifiable(_exercisesList);

  void addExercise(Exercise exercise) {
    _exercisesList.add(exercise);
    _exercisesList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void updateExercise(Exercise oldExercise, Exercise exercise) {
    final index = _exercisesList.indexWhere((e) => e.id == oldExercise.id);
    if (index != -1) {
      _exercisesList[index] = exercise;
      _exercisesList.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    }
  }

  void removeExercise(Exercise exercise) {
    _exercisesList.remove(exercise);
    notifyListeners();
  }

  void clearExercises() {
    _exercisesList.clear();
    notifyListeners();
  }
}