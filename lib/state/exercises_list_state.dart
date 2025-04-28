import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListState extends ChangeNotifier {
  final List<Exercise> _exercises = [];
  
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  Future<bool> addExercise(Exercise exercise) async {
    _exercises.add(exercise);
    _exercises.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
    return true;
  }

  Future<bool> updateExercise(Exercise exercise) async {
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if(index == -1) return false;

    _exercises[index] = exercise;
    _exercises.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
    return true;
  }

  Future<bool> removeExercise(Exercise exercise) async {
    _exercises.remove(exercise);
    notifyListeners();
    return true;
  }

  Future clearExercises() async {
    _exercises.clear();
    notifyListeners();
  }
}